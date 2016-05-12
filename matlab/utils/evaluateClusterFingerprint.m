function fingerprint = evaluateClusterFingerprint(images)
    database_size = length(images);
    sigma = 3; % local std of extracted noise

    %%%  Parameters used in denoising filter
    L = 4;                                      %  number of decomposition levels
       qmf = MakeONFilter('Daubechies',8);

    t = 0; 
    
    for i=1:database_size
       % SeeProgress(i),
        im = images(i).name;
        X = imread(im); 
        X = double2range(X);
        if t == 0
            [M, N, three] = size(X);
            if three == 1 
                continue;                           % only color images will be processed    
            end
            %%%  Initialize sums 
            for j = 1:3
                RPsum{j} = zeros(M, N, 'single');   
                NN{j} = zeros(M, N, 'single');        	% number of additions to each pixel for RPsum
            end
        else
            s = size(X);
            if length(size(X)) ~= 3, 
                fprintf('Not a color image - skipped.\n');
                continue;                           % only color images will be used 
            end
            if any([M,N,three] ~= size(X))
                fprintf('\n Skipping image %s of size %d x %d x %d \n',im,s(1),s(2),s(3));
                continue;                           % only same size images will be used 
            end
        end
        % The image will be the t-th image used for the reference pattern RP
        t= t + 1;                                      % counter of used images
        ImagesinRP(t).name = im;

        mat = matfile(['mat/image_prnu_' num2str(i) '.mat']);
        PRNU = mat.PRNU;
        for j = 1:3
            ImNoise = single(PRNU(:, :, j));
            Inten = single(IntenScale(X(:, :, j))) .* Saturation(X(:, :, j));    % zeros for saturated pixels
            RPsum{j} = RPsum{j} + ImNoise .* Inten;   	% weighted average of ImNoise (weighted by Inten)
            NN{j} = NN{j} + Inten.^2;
        end
        clear PRNU mat;

    end

    clear ImNoise Inten X
    if t==0
        error('None of the images was color image in landscape orientation.') 
    end
    RP = cat(3,RPsum{1}./(NN{1}+1),RPsum{2}./(NN{2}+1),RPsum{3}./(NN{3}+1));
    % Remove linear pattern and keep its parameters
    [RP, ~] = ZeroMeanTotal(RP);
    RP = single(RP);               % reduce double to single precision 
    
    RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
    fingerprint = WienerInDFT(RP,sigmaRP);
end
    
    

