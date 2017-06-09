function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% add bias terms to X
X = [ones(m,1) X];


% cost function, feed forward
a1 = X;                % 5000x401
z2 = X * Theta1';      % 5000x25
a2 = sigmoid(z2);      % 5000x25

%add bias term to a2 
a2 = [ones(m,1) a2];   % 5000x26 
z3 = a2 * Theta2';     % 5000x10  
a3 = sigmoid(z3);      % 5000x10
hTheta = a3;

% change values of y from integers to vectors
% create a temp vector of zeros of size hTheta'

temp_vec = zeros(size(hTheta));

% for each value of y set temp_vec(value) = 1;
% we can loop over y
for i= 1:m
    temp_vec(i,y(i)) = 1;
end

%set temp_vec back to y
y = temp_vec;


%calculate J

for i = 1:m
    for k = 1:num_labels
        J = J + (-y(i,k) * log(hTheta(i,k)) - (1-y(i,k))*log(1-hTheta(i,k)));
    end
end

J = J/m;
 
 
 
% calculate regularized terms for adding in cost function.
% it is equal to lambda/2m * sum of individual squares of all theta elements excluding first column (bias values)
reg = (lambda/(2*m)) *(sum(sum(Theta1(:,2:end).^2))+sum(sum(Theta2(:,2:end).^2)));

J = J + reg;


% backpropagation

delta3 = a3 - y;
delta2 = (delta3*Theta2(:,2:end)) .* sigmoidGradient(z2);
%for t = 1:m
%    a1 = X(t,:)';
%    z2 = Theta1 * a1;
%    a2 = sigmoid(z2);
%    % add bias value to a2
%    a2 = [1; a2];
%    z3 = Theta2 * a2;
%    a3 = sigmoid(z3);
    
    % get delta 3
    %for k = 1:num_labels
     %   delta3(k,1) = a3(k) - y(t,k);
    %end   
       
    % or this can be written as 
%    delta3 = a3 - y(t,:)';
    
%    delta2 = ((Theta2'(2:end,:)) * delta3) .* sigmoidGradient(z2);
    
DELTA2 = delta3'*a2; 
DELTA1 = delta2'*a1;
%end    

Theta1_grad = DELTA1/m;
Theta2_grad = DELTA2/m;


% for regularization;
regTheta1 = Theta1;
regTheta1(:,1) = 0;
regTheta2 = Theta2;
regTheta2(:,1) = 0;

Theta1_grad = Theta1_grad + (lambda/m)*regTheta1;
Theta2_grad = Theta2_grad + (lambda/m)*regTheta2;



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end