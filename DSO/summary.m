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


  function [summ] = summary (data)
    % summ.Min = min(data);
    % summ.qt1 = quantile(data, 0.25);
    % summ.Median = median(data);
    % summ.Mean = mean(data);    
    % summ.qt3 = quantile(data, 0.75);
    % summ.Max = max(data);
    % summ.Stdev = std(data);
    data(isinf(data)) = 0;

    fprintf(1, 'min=%e\nq1=%e\nmedian=%e\nmean=%e\nq3=%e\nmax=%e\nsd=%e\n', min(data), quantile(data, 0.25), median(data), mean(data), quantile(data, 0.75), max(data), std(data));

    summ = [min(data); quantile(data, 0.25); median(data); mean(data); quantile(data, 0.75); max(data); std(data)]';
  end
