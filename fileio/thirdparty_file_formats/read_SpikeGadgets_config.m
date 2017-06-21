function [out,officialchannels] = read_SpikeGadgets_config(filename)
 % out = read_SpikeGadgets_config(filename)
 %
 % Reads the configuration section of a Trodes (.rec) file
 % xml header is parsed and read
 % out is a 1x1 struct with 12 fields
 % configText - length(configText) is the number of characters in header
 % filePath               - <--->
 % filePrefix             - <--->
 % realtimeMode           - logical
 % saveDisplayedChanOnly  - logical
 % systemTimeAtCreation   - str with systemTimeAtCreation
 % timestampAtCreation    - str with timestampAtCreation
 % numChannels            - str of number of channels in nTrodes (sum of all trodes channels)
 % samplingRate           - str of sampling rate
 % headerSize             - str of sum of numBytes in devices / 2
 % nTrodes                - struct that lists nTrodes with structs inside that describe each channel
 % headerChannels         - channels listed in AuxDisplayConfiguration


    %Open file for reading file id assigned to fid
    fid = fopen(filename,'r');
    %Displays error if couldn't be opened
    if (fid == -1)
        error('Error opening file.');
    end

    %Initialize headersize
    headersize = 0;

    %Reads a million char into junk
    junk = fread(fid,1000000,'char');
    %Junk transposed -> junk' (proper display of text from vertical to horizontal)
    %Looks for the index where </Configuration> is found
    %Adds 16 (length of </Configuration>)
    headersize = strfind(junk','</Configuration>')+16;
    frewind(fid);

    %Configuration saved to headerText
    headerText = fread(fid,headersize,'char');
    fclose(fid);

    %Temporary xml file to easily access information
    fid = fopen('tmpheaderfile.xml','w');
    fwrite(fid,headerText);

    fclose(fid);

    %Parses xml to DOM node saved in tree
    tree = xmlread('tmpheaderfile.xml');

    %Starts parsing child nodes
    try
       headerStruct = parseChildNodes(tree);
    catch
       error('Unable to parse XML');
    end
    delete('tmpheaderfile.xml');

    %Variables where child index is stored
    globalOptionsInd = [];
    streamingInd = [];
    spikeInd = [];
    headerInd = [];
    hardwareInd = [];

    %Out is returned by function
    out = [];
    %Adds the config text as field read from junk
    out.configText = junk(1:headersize);
    %Finds indices and stores them in respective variables
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
    %If 'GlobalOptions' or 'GlobalConfiguration' found in child nodes
    if (~isempty(globalOptionsInd))
        %Attributes saved to tmp
        tmp = headerStruct.Children(globalOptionsInd).Attributes;
        %Every attribute with value saved to out
        for i = 1:length(tmp)
            out = setfield(out,tmp(i).Name,tmp(i).Value);
            %filePrefix
            %timestampAtCreation
            %realtimeMode
            %saveDisplayedChanOnly
            %filePath
            %systemTimeAtCreation
        end
    end

    %Read in the hardware device list
    deviceList = [];
    %If 'HardwareConfiguration' found in child nodes
    if (~isempty(hardwareInd))
        %Attributes saved to hardwareInfoStruct
        hardwareInfoStruct = headerStruct.Children(hardwareInd).Attributes;
        %Every attribute with value saved to out
        for i = 1:length(hardwareInfoStruct)
             out = setfield(out,hardwareInfoStruct(i).Name,hardwareInfoStruct(i).Value);
             %numChannels
             %samplingRate
        end

        %Children of HardwareConfiguration (Devices) saved to hardwareStruct
        hardwareStruct = headerStruct.Children(hardwareInd).Children;

        %Helper variables
        numDevices = 0;
        totalHeaderSize = 1;
        deviceByteSize = [];
        deviceOrder = [];

        channelnumber = 0;
        %These are all the channels in device
        officialchannels = [];

        %For every field in hardwareStruct
        for i = 1:length(hardwareStruct)
            %If hardwareStruct field and 'Device' match
            if (isequal(hardwareStruct(i).Name,'Device'))
                %We increase the number of devices
                numDevices = numDevices + 1;
                %We get the devices info attributes saved to deviceInfoStruct
                deviceInfoStruct = hardwareStruct(i).Attributes;
                %For every info attribute of device
                for devInf = 1:length(deviceInfoStruct)
                    %Saved to deviceList as fields and values
                    deviceList = setfield(deviceList,{numDevices},deviceInfoStruct(devInf).Name,deviceInfoStruct(devInf).Value);
                    %name
                    %numBytes
                    %packetOrderPreference
                    %available

                    %fprintf('deviceInfoStruct(devInf).Name: %s , deviceInfoStruct(devInf).Value: %s \n',deviceInfoStruct(devInf).Name,deviceInfoStruct(devInf).Value);
                end
                %If device attribute available == 1
                if (str2num(deviceList(numDevices).available) == 1)
                    %Adds numBytes to totalHeaderSize
                    totalHeaderSize = totalHeaderSize+str2num(deviceList(numDevices).numBytes);
                    %Adds numBytes to end of deviceByteSize
                    deviceByteSize = [deviceByteSize (deviceList(numDevices).numBytes)];
                    %Adds packetOrderPreference to end of deviceOrder
                    deviceOrder = [deviceOrder str2num(deviceList(numDevices).packetOrderPreference)];

                    tmpDeviceChannelList = [];
                    %Counter for channels in devices
                    numDevChannels = 0;
                    %We get the device's channels saved to deviceChannelStruct (children of devices)
                    deviceChannelStruct = hardwareStruct(i).Children;

                    %For every channel in device
                    for devChannel = 1:length(deviceChannelStruct)
                        %If name equals 'Channel'
                        if (isequal(deviceChannelStruct(devChannel).Name,'Channel'))
                            %Increase counter for channels
                            numDevChannels = numDevChannels+1;
                            %We save channel attributes to channelInfoStruct
                            channelInfoStruct = deviceChannelStruct(devChannel).Attributes;
                            %For every info attribute of channel
                            for chInf = 1:length(channelInfoStruct)
                                %Saved to tmpDeviceChannelList as fields and values
                                tmpDeviceChannelList = setfield(tmpDeviceChannelList,{numDevChannels},channelInfoStruct(chInf).Name,channelInfoStruct(chInf).Value);
                                %bit
                                %dataType
                                %id
                                %input
                                %startByte

                                %fprintf('channelInfoStruct(chInf).Name: %s , channelInfoStruct(chInf).Value: %s \n',channelInfoStruct(chInf).Name,channelInfoStruct(chInf).Value);

                                %DEBUG HELP, the fieldnames are checked in
                                %alphabetical order so be sure to have the variables below
                                %bit,dataType,id and startByte in alphabetical
                                %order

                                %Saves every info attribute for each numbered channel --> channelnumber
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
        %To correct order of fields in struct
        %Desired order is correctOrder
        correctOrder = emptystruct('name','type','startbyte','bit');
        %Order fields accordingly
        officialchannels = orderfields(officialchannels, correctOrder);

        %headerSize as str saved to out as field
        out.headerSize = num2str(totalHeaderSize / 2);

        %Calculate the packet offset of each device based on the 'packetOrderPreference' values
        filteredDevInd = find(deviceOrder > -1);
        %Sorts according to packet offset
        [filteredDevOrder sortInd] = sort(deviceOrder(filteredDevInd));
        sortedDevices = filteredDevInd(sortInd);
        offsetSoFar = 1; %the first byte is always a sync byte
        for (devInd = 1:length(sortedDevices))
            deviceList(sortedDevices(devInd)).packetOffset = offsetSoFar;
            offsetSoFar = offsetSoFar+str2num(deviceList(sortedDevices(devInd)).numBytes);
        end

    end


    %Now we compile the information for each nTrode
    numCards = str2num(out.numChannels) / 32;
    completeChannelList = [];
    %Starts reading SpikeConfiguration
    if (~isempty(spikeInd))
        %Trode info saved to out.nTrodes
        out.nTrodes = [];
        %Trode list of the SpikeConfiguration saved to nTrodeStruct
        nTrodeStruct = headerStruct.Children(spikeInd).Children;
        %Trode counter
        currentTrode = 0;
        %For every trode found
        for i = 1:length(nTrodeStruct)
            %If name is a SpikeNTrode
            if (isequal(nTrodeStruct(i).Name,'SpikeNTrode'))
                %Increase counter
                currentTrode = currentTrode + 1;
                out.nTrodes(currentTrode).channelInfo = [];
                %Trode attributes stored to tmp
                tmp = nTrodeStruct(i).Attributes;
                %For every trode attribute, save as field and value
                for j = 1:length(tmp)
                    out.nTrodes = setfield(out.nTrodes,{currentTrode},tmp(j).Name,tmp(j).Value);
                end
                currentChannel = 0;
                %For every SpikeChannel in a trode
                for k = 1:length(nTrodeStruct(i).Children)
                    %If element name is SpikeChannel
                    if (isequal(nTrodeStruct(i).Children(k).Name,'SpikeChannel'))
                        currentChannel = currentChannel + 1;
                        %Store channel attributes to tmp
                        tmp = nTrodeStruct(i).Children(k).Attributes;
                        %For every attribute
                        for l = 1:length(tmp)
                            %If element name is a hwChan
                            if isequal(tmp(l).Name,'hwChan')
                                %if there are multiple headstages, the channels are interlaced in
                                %the file, so we need to convert the HW channels to the interlaced
                                %form.

                                hwRead = str2num(tmp(l).Value);
                                new_hw_chan =  (mod(hwRead,32)*numCards)+floor(hwRead/32);
                                %Update completeChannelList
                                completeChannelList = [completeChannelList new_hw_chan];
                                out.nTrodes(currentTrode).channelInfo(currentChannel).packetLocation = new_hw_chan;

                            else
                                %Store current channel attribute to channelInfo
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

    %Sorts list in the senjfn j
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
        %We store auxiliary configuration channels to headerInfo
        headerInfo = headerStruct.Children(headerInd).Children;
        currentChannel = 0;
        digitalChannels = [];
        analogChannels = [];
        %For every channel
        for i = 1:length(headerInfo)
            %Check name match
            if (isequal(headerInfo(i).Name,'HeaderChannel') || isequal(headerInfo(i).Name,'DispChannel'))
                %Increase counter
                currentChannel = currentChannel + 1;
                tmpChannelInfo = [];
                %We store channel attributes to tmp
                tmp = headerInfo(i).Attributes;
                channelDeviceName = '';
                channelID = '';
                %For every attribute in channel
                for l = 1:length(tmp)
                    %Store it as field
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

                                    %We store startByte
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
end
