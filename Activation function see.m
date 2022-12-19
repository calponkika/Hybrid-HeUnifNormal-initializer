function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 19-Nov-2022 09:39:33.
% 
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 4xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 3xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [4.3;2;1;0.1];
  x1_step1_gain = [0.555555555555555;0.833333333333333;0.338983050847458;0.833333333333333];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [2.5076091112962371;-1.5798948867815785;-0.93031981405712816;-1.8329805856781622;-0.34333069639266545;-1.3018588559078357;-0.86002321055187991;1.4413382258783121;-1.7020586653417353;2.4210877289440513];
  IW1_1 = [-1.6074541883746754 -1.6820248859302174 -0.34007712323290051 0.72655562214462244;1.2967510627952485 -1.0696049524216051 2.1541836360220903 1.4960418652144551;1.3273313572877983 -1.7619269405383198 1.2543971271078735 -0.78139385207535272;0.45632824600649891 -0.0040594921421793911 -2.0934283671684515 -2.2084101683084953;1.8103581631572392 1.5649230021041782 0.056468919314194427 0.0082151371413323668;-0.2908463436805489 -0.097549596370842179 1.1417088118550529 3.09693448232865;-0.56994369301243675 -1.4116048116561319 2.2393054079458667 -0.26139388740218444;0.58692350499612189 1.6303322364373014 1.7597940828706939 1.2779817920869523;-0.96499464634157972 -1.8558829964914265 1.4276146018557758 -0.6145124540210698;1.3396888104596634 -0.39135013118739287 -1.3480143163322635 1.6279870611851794];
  
  % Layer 2
  b2 = [-0.88979303967125001;-0.014722919562545581;0.63234576278897769];
  LW2_1 = [-0.50899883053051143 0.50231336432889384 -1.3483278827494345 3.0396269129957498 -0.26099675385039428 -1.755814559761689 -0.89316192373374392 -0.5505326698955596 -0.76486385329573203 -0.39824301650459965;0.024481410796745803 -0.77932578510105699 -0.27904194115169845 -1.7734220257770825 0.80366806585004869 -1.7148421032387451 -0.42276265137631674 0.36196554750653892 0.32609432571949371 0.18614180811640074;0.40477519929595984 2.071832836182256 -0.28177677107592153 -0.44763636517064864 -0.49712659620560301 2.5981042321081915 1.6274785428340941 1.2929298489363674 1.0323062119954174 -0.73965523708451875];
  
  % ===== SIMULATION ========
  
  % Format Input Arguments
  isCellX = iscell(X);
  if ~isCellX, X = {X}; end;
  
  % Dimensions
  TS = size(X,2); % timesteps
  if ~isempty(X)
    Q = size(X{1},2); % samples/series
  else
    Q = 0;
  end
  
  % Allocate Outputs
  Y = cell(1,TS);
  
  % Time loop
  for ts=1:TS
  
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = softmax_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Output 1
    Y{1,ts} = a2;
  end
  
  % Final Delay States
  Xf = cell(1,0);
  Af = cell(2,0);
  
  % Format Output Arguments
  if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
  y = bsxfun(@minus,x,settings_xoffset);
  y = bsxfun(@times,y,settings_gain);
  y = bsxfun(@plus,y,settings_ymin);
end

% Competitive Soft Transfer Function
function a = softmax_apply(n)
  nmax = max(n,[],1);
  n = bsxfun(@minus,n,nmax);
  numer = exp(n);
  denom = sum(numer,1); 
  denom(denom == 0) = 1;
  a = bsxfun(@rdivide,numer,denom);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end