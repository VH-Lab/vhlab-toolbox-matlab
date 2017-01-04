function indexes = scramblepixels_movie(infile, outfile)
% SCRAMBLEPIXELS_MOVIE - Scramble the pixels within a movie
%
%
%  INDEXES = SCRAMBLEPIXELS_MOVIE(INFILE, OUTFILE)
%
%  Scramble the pixels within a movie to illustrate the power
%  of the mammalian visual system

vr = VideoReader(infile);

params = get(vr);

vo = VideoWriter(outfile);
set(vo,'FrameRate',params.FrameRate);

open(vo);

f = figure;
beforeaxes = subplot(2,2,1);
afteraxes = subplot(2,2,2);

indexes = [];

h = waitbar(0);

while hasFrame(vr),
	vidFrame = readFrame(vr);
    for i=1:size(vidFrame,3),
        vf{i} = vidFrame(:,:,i);
    end;
	if isempty(indexes),
		indexes = randperm(numel(vf{1}));
		%indexes = 1:numel(vidFrame);
	end;
    for i=1:size(vidFrame,3),
    	vf{i}(indexes) = vf{i}(:);
    end;

    newFrame = cat(3,vf{:});
    image(vidFrame, 'Parent', beforeaxes);
    image(newFrame, 'Parent', afteraxes);
	drawnow;
	writeVideo(vo,newFrame);
	waitbar(vr.CurrentTime/vr.Duration,h);
    figure(h);
	drawnow;

end;

delete(h);
close(f);
close(vo);
