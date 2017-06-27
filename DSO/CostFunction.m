%______________________________________________________________________________________________
%  DRONE SQUADRON OPTIMIZATION Algorithm (DSO) toolbox                                                            
%  Source codes demo version 1.0
%                                                                                                     
%  Developed in Octave 3.8. Compatible with MATLAB 2011
%                                                                                                     
%  Author and programmer: Vinicius Veloso de Melo
%                                                                                                     
%         e-Mail: dr.vmelo@gmail.com                                                             
%                 vinicius.melo@unifesp.br                                               
%                                                                                                     
%       Homepage: http://www.sjc.unifesp.br/docente/vmelo/                                                         
%                                                                                                     
%  Main paper:                                                                                        
%  de Melo, V.V. & Banzhaf, W. Neural Comput & Applic (2017). doi:10.1007/s00521-017-2881-3
%  link.springer.com/article/10.1007/s00521-017-2881-3
%_______________________________________________________________________________________________


% Input: an array
% Output: The objective function value

function Cost = CostFunction( x )
	dimension = length(x);
	Cost = sum(100*(x(2:dimension)-x(1:dimension-1).^2).^2 + (1-x(1:dimension-1)).^2);  % Rosenbrock function
end

% 
% function Cost = CostFunction( x )
% dim=size(x,2);
% Cost=sum(x.^2); % Sphere function
% end
% 
