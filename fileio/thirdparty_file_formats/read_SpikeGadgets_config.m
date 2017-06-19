function [out,officialchannels] = read_SpikeGadgets_config(filename)
%out = readTrodesFileConfig(filename)
%
%Reads the configuration section of a Trodes (.rec) file


fid = fopen(filename,'r');
if (fid == -1)
    error('Error opening file.');
end

headersize = 0;

junk = fread(fid,1000000,'char');
headersize = strfind(junk','</Configuration>')+16;
frewind(fid);

headerText = fread(fid,headersize,'char');
fclose(fid);

fid = fopen('tmpheaderfile.xml','w');
fwrite(fid,headerText);

fclose(fid);

tree = xmlread('tmpheaderfile.xml');
try
   headerStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML');
end
delete('tmpheaderfile.xml');

globalOptionsInd = [];
streamingInd = [];
spikeInd = [];
headerInd = [];
hardwareInd = [];

out = [];
out.configText = junk(1:headersize);
for i = 1:length(headerStruct.Children)
    if isequal(headerStruct.Children(i).Name, 'GlobalOptions')
        globalOptionsInd = i;
    elseif isequal(headerStruct.Children(i).Name, 'GlobalConfiguration')
        globalOptionsInd = i;
    elseif isequal(headerStruct.Children(i).Name, 'HardwareConfiguration')
        hardwareInd = i;    
    elseif isequal(headerStruct.Children(i).Name, 'StreamDisplay')
        streamingInd = i;
    elseif isequal(headerStruct.Children(i).Name, 'HeaderDisplay')
        headerInd = i;
    elseif isequal(headerStruct.Children(i).Name, 'AuxDisplayConfiguration')
        headerInd = i;    
    elseif isequal(headerStruct.Children(i).Name, 'SpikeConfiguration')
        spikeInd = i;
    end
end

%Read in the global configuration
if (~isempty(globalOptionsInd))
    tmp = headerStruct.Children(globalOptionsInd).Attributes;
    for i = 1:length(tmp)
        out = setfield(out,tmp(i).Name,tmp(i).Value);
    end
end

%Read in the hardware device list
deviceList = [];
if (~isempty(hardwareInd))
    hardwareInfoStruct = headerStruct.Children(hardwareInd).Attributes;
    for i = 1:length(hardwareInfoStruct)  
         out = setfield(out,hardwareInfoStruct(i).Name,hardwareInfoStruct(i).Value);       
    end
    hardwareStruct = headerStruct.Children(hardwareInd).Children;
    
    numDevices = 0;
    totalHeaderSize = 1;
    deviceByteSize = [];
    deviceOrder = [];
    
    channelnumber = 0;
    officialchannels = [];
    for i = 1:length(hardwareStruct)
        if (isequal(hardwareStruct(i).Name,'Device'))
            numDevices=numDevices+1;            
            deviceInfoStruct = hardwareStruct(i).Attributes;
            for devInf = 1:length(deviceInfoStruct)
                deviceList = setfield(deviceList,{numDevices},deviceInfoStruct(devInf).Name,deviceInfoStruct(devInf).Value);
                %fprintf('deviceInfoStruct(devInf).Name: %s , deviceInfoStruct(devInf).Value: %s \n',deviceInfoStruct(devInf).Name,deviceInfoStruct(devInf).Value);
            end
            if (str2num(deviceList(numDevices).available) == 1)
                totalHeaderSize = totalHeaderSize+str2num(deviceList(numDevices).numBytes);
                %fprintf('numbytes: %s ', deviceList(numDevices).numBytes);
                deviceByteSize = [deviceByteSize (deviceList(numDevices).numBytes)];
                deviceOrder = [deviceOrder str2num(deviceList(numDevices).packetOrderPreference)];

                tmpDeviceChannelList = [];
                numDevChannels = 0;
                deviceChannelStruct = hardwareStruct(i).Children;
                for devChannel = 1:length(deviceChannelStruct)
                    if (isequal(deviceChannelStruct(devChannel).Name,'Channel'))
                        numDevChannels = numDevChannels+1;
                        channelInfoStruct = deviceChannelStruct(devChannel).Attributes;
                        
                        for chInf = 1:length(channelInfoStruct)
                            tmpDeviceChannelList = setfield(tmpDeviceChannelList,{numDevChannels},channelInfoStruct(chInf).Name,channelInfoStruct(chInf).Value);
                            %fprintf('channelInfoStruct(chInf).Name: %s , channelInfoStruct(chInf).Value: %s \n',channelInfoStruct(chInf).Name,channelInfoStruct(chInf).Value);
                            
                            %DEBUG HELP, the fieldnames are checked in
                            %alphabetical order so be sure to have
                            %bit,dataType,id and startByte in alphabetical
                            %order
                        
                            if (strcmp(channelInfoStruct(chInf).Name, 'bit'))
                                channelnumber = channelnumber + 1;
                                officialchannels(channelnumber).bit = channelInfoStruct(chInf).Value;
                            end
                            
                            if (strcmp(channelInfoStruct(chInf).Name,'dataType'));
                                officialchannels(channelnumber).type = channelInfoStruct(chInf).Value;
                            end
                            
                            if (strcmp(channelInfoStruct(chInf).Name,'id'))
                                officialchannels(channelnumber).name = channelInfoStruct(chInf).Value;
                            end
                            
                            if (strcmp(channelInfoStruct(chInf).Name, 'startByte'))
                                officialchannels(channelnumber).startbyte = channelInfoStruct(chInf).Value;
                            end
                            
                            
                        end
                        
                    end
                end
                deviceList(numDevices).channels = tmpDeviceChannelList;
            else
                deviceOrder = [deviceOrder -1];
                deviceByteSize = [deviceByteSize -1];
            end
        end    
    end
    correctOrder = emptystruct('name','type','startbyte','bit');
    officialchannels = orderfields(officialchannels, correctOrder);
    
    out.headerSize = num2str(totalHeaderSize/2);
    
    %Calculate the packet offet of each device based on the 'packetOrderPreference' values 
    filteredDevInd = find(deviceOrder > -1);
    [filteredDevOrder sortInd] = sort(deviceOrder(filteredDevInd));
    sortedDevices = filteredDevInd(sortInd);
    offsetSoFar = 1; %the first byte is always a sync byte
    for (devInd = 1:length(sortedDevices))       
        deviceList(sortedDevices(devInd)).packetOffset = offsetSoFar;
        offsetSoFar = offsetSoFar+str2num(deviceList(sortedDevices(devInd)).numBytes);
    end
    
end


%Now we compile the information for each nTrode
numCards = str2num(out.numChannels)/32;
completeChannelList = [];
if (~isempty(spikeInd))
    out.nTrodes = [];
    nTrodeStruct = headerStruct.Children(spikeInd).Children;
    currentTrode = 0;
    for i = 1:length(nTrodeStruct)
        if (isequal(nTrodeStruct(i).Name,'SpikeNTrode'))
            currentTrode = currentTrode+1;
            out.nTrodes(currentTrode).channelInfo = [];
            tmp = nTrodeStruct(i).Attributes;
            for j = 1:length(tmp)
                out.nTrodes = setfield(out.nTrodes,{currentTrode},tmp(j).Name,tmp(j).Value);
            end
            currentChannel = 0;
            for k = 1:length(nTrodeStruct(i).Children)
                if (isequal(nTrodeStruct(i).Children(k).Name,'SpikeChannel'))
                    currentChannel = currentChannel+1;
                    tmp = nTrodeStruct(i).Children(k).Attributes;
                    for l = 1:length(tmp)
                        if isequal(tmp(l).Name,'hwChan')
                            %if there are multiple headstages, the channels are interlaced in
                            %the file, so we need to convert the HW channels to the interlaced
                            %form.
        
                            hwRead = str2num(tmp(l).Value);
                            new_hw_chan =  (mod(hwRead,32)*numCards)+floor(hwRead/32);  
                            completeChannelList = [completeChannelList new_hw_chan];
                            out.nTrodes(currentTrode).channelInfo(currentChannel).packetLocation = new_hw_chan;
                            
                        else 
                            out.nTrodes(currentTrode).channelInfo = setfield(out.nTrodes(currentTrode).channelInfo,{currentChannel},tmp(l).Name,tmp(l).Value);

                        end
                    end
                end
                    
            end
        end
    end
end


%Now we need to see if all channels were saved to disk.  If not, then we
%need to modify the info to match the actual channel locations in each saved packet 

completeChannelList = sort(completeChannelList);
numChanIn = str2num(out.numChannels);
unusedChannels = setdiff((0:(numChanIn-1)),completeChannelList);
numChanInFile = numChanIn-length(unusedChannels);
out.numChannels = num2str(numChanInFile);

if (isfield(out, 'saveDisplayedChanOnly') && isequal(getfield(out, 'saveDisplayedChanOnly'),'1') && ~isempty(unusedChannels))
    %Some channels were not saved
       
    for nTrodeInd = 1:length(out.nTrodes)
        for channelInd = 1:length(out.nTrodes(nTrodeInd).channelInfo)
            %tmpHWChan = str2num(out.nTrodes(nTrodeInd).channelInfo(channelInd).hwChan);
            tmpHWChan =  out.nTrodes(nTrodeInd).channelInfo(channelInd).packetLocation;
            tmpUsedChannelInd = find(completeChannelList==tmpHWChan,1);
            skippedChannelsUptoThisChan = sum(diff(completeChannelList(1:tmpUsedChannelInd))-1);
            %adjust the hwChan value to match what is in the file structure            
            out.nTrodes(nTrodeInd).channelInfo(channelInd).packetLocation = tmpHWChan-skippedChannelsUptoThisChan;
        end
    end    
end


%If auxilliary channels were defined, we pull out that info too
if (~isempty(headerInd))
    out.headerChannels = [];
    headerInfo = headerStruct.Children(headerInd).Children;
    currentChannel = 0;
    digitalChannels = [];
    analogChannels = [];
    for i = 1:length(headerInfo)
        if (isequal(headerInfo(i).Name,'HeaderChannel') || isequal(headerInfo(i).Name,'DispChannel'))           
            currentChannel = currentChannel+1;
            tmpChannelInfo = [];
            tmp = headerInfo(i).Attributes;
            channelDeviceName = '';
            channelID = '';
            for l = 1:length(tmp)
                out.headerChannels = setfield(out.headerChannels,{currentChannel},tmp(l).Name,tmp(l).Value);
                if isequal(tmp(l).Name,'device')
                      channelDeviceName =  tmp(l).Value;                 
                end
                if isequal(tmp(l).Name,'id')
                      channelID =  tmp(l).Value;              
                end
                                             
            end
            
            if (~isempty(channelDeviceName) && ~isempty(channelID))
                %The channel is referencing a channel in the hardware
                %device list, so we need to append that info 
                for devInd = 1:length(deviceList)
                    if isequal(channelDeviceName,deviceList(devInd).name)
                        %We found the device that the channel belongs
                        %to, so look up the right channel
                        for hardwareChInd = 1:length(deviceList(devInd).channels)
                            if isequal(channelID,deviceList(devInd).channels(hardwareChInd).id)
                                %We found the right channel
                                fN = fieldnames(deviceList(devInd).channels(hardwareChInd));
                               
                                sB = str2num(deviceList(devInd).channels(hardwareChInd).startByte)+deviceList(devInd).packetOffset;
                                sB = num2str(sB);
                                
                                for fieldInd = 1:length(fN)
                                     out.headerChannels = setfield(out.headerChannels,{currentChannel},fN{fieldInd},getfield(deviceList(devInd).channels(hardwareChInd),fN{fieldInd}));
                                     out.headerChannels(currentChannel).startByte = sB;
                                end
                                break;
                            end                                                        
                        end
                        break;
                    end
                end
            end
        end
    end
end


    


%--------------------------------------------------------------------

% ----- Local function PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end

% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end

% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end

