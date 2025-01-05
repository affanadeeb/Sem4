clc;
clear all;

numTransmittedSymbols = 1000;
modulationOrder = 16;
EbN0dBValues = [0, 4, 10];
maxIterations = 10; % Setting max number of iterations

idx = 1;
iterationCount = 0;

while true
    transmittedSymbols = randi([0 modulationOrder-1], 1, numTransmittedSymbols);
    [qamModulatedSymbols, pamModulatedSymbols, askModulatedSymbols, fskModulatedSymbols] = generateModulatedSymbols(transmittedSymbols, modulationOrder);
    [receivedQAMSignal, receivedPAMSignal, receivedASKSignal, receivedFSKSignal] = addNoise(qamModulatedSymbols, pamModulatedSymbols, askModulatedSymbols, fskModulatedSymbols, EbN0dBValues(idx));
    
    % MAP detector for 16-ary QAM
    detectedQAMSymbols = mapDetectorQAM(receivedQAMSignal, modulationOrder);
    
    % MAP detector for 16-ary ASK
    detectedASKSymbols = mapDetectorASK(receivedASKSignal, modulationOrder);
    
    % MAP detector for 16-ary FSK
    detectedFSKSymbols = mapDetectorFSK(receivedFSKSignal, modulationOrder);
    
    plotQAMConstellation(receivedQAMSignal, EbN0dBValues(idx), 'Constellation of Received QAM Signal', 'b*', [-5 5 -5 5]);
    plotPAMConstellation(receivedPAMSignal, EbN0dBValues(idx), 'Constellation of Received PAM Signal', 'ro', [-20 20 -5 5]);
    
    iterationCount = iterationCount + 1;
    
    if iterationCount >= maxIterations || idx >= length(EbN0dBValues)
        break;
    end
    
    % Increment index
    idx = idx + 1;
end

function qamModulatedSymbols = myQAMModulation(transmittedSymbols, modulationOrder)
    % QAM modulation
    M = sqrt(modulationOrder);
    qamModulatedSymbols = zeros(1, length(transmittedSymbols));
    
    for i = 1:length(transmittedSymbols)
        I = floor(transmittedSymbols(i) / M);
        Q = mod(transmittedSymbols(i), M);
        qamModulatedSymbols(i) = (2*I - M + 1) + 1i*(2*Q - M + 1);
    end
end

function pamModulatedSymbols = myPAMModulation(transmittedSymbols, modulationOrder)
    % PAM modulation
    pamModulatedSymbols = (2 * transmittedSymbols - modulationOrder + 1);
end

function [qamModulatedSymbols, pamModulatedSymbols, askModulatedSymbols, fskModulatedSymbols] = generateModulatedSymbols(transmittedSymbols, modulationOrder)
    qamModulatedSymbols = myQAMModulation(transmittedSymbols, modulationOrder);
    pamModulatedSymbols = myPAMModulation(transmittedSymbols, modulationOrder);
    
    % ASK modulation
    askModulatedSymbols = sqrt(2/modulationOrder) * cos(pi/modulationOrder * transmittedSymbols);
    
    % FSK modulation
    fskModulatedSymbols = zeros(1, length(transmittedSymbols));
    for i = 1:length(transmittedSymbols)
        fskModulatedSymbols(i) = cos(2*pi*(transmittedSymbols(i)+1)*i/length(transmittedSymbols));
    end
end

function [receivedQAMSignal, receivedPAMSignal, receivedASKSignal, receivedFSKSignal] = addNoise(qamModulatedSymbols, pamModulatedSymbols, askModulatedSymbols, fskModulatedSymbols, EbN0dB)
    SNR = 10^(EbN0dB/10);
    noiseVariance = 1 / SNR;
    noise = sqrt(noiseVariance/2) * (randn(1, length(qamModulatedSymbols)) + 1i*randn(1, length(qamModulatedSymbols)));
    
    receivedQAMSignal = qamModulatedSymbols + noise;
    receivedPAMSignal = pamModulatedSymbols + noise;
    receivedASKSignal = askModulatedSymbols + noise;
    receivedFSKSignal = fskModulatedSymbols + noise;
end

function plotQAMConstellation(receivedQAMSignal, EbN0dB, title_str, marker_style, axis_limits)
    figure;
    subplot(2, 1, 1);
    scatter(real(receivedQAMSignal), imag(receivedQAMSignal), marker_style);
    xlabel('Real');
    ylabel('Imaginary');
    title([title_str ' at Eb/No = ' num2str(EbN0dB) ' dB']);
    axis(axis_limits);
    
    y_min = min(imag(receivedQAMSignal));
    y_max = max(imag(receivedQAMSignal));
    y_range = y_max - y_min;
    ylim([y_min - 0.1*y_range, y_max + 0.1*y_range]); 
    
    grid on;
end


function plotPAMConstellation(receivedPAMSignal, EbN0dB, title_str, marker_style, axis_limits)
    subplot(2, 1, 2);
    scatter(real(receivedPAMSignal), imag(receivedPAMSignal), marker_style);
    xlabel('Real');
    ylabel('PAM');
    title([title_str ' at Eb/No = ' num2str(EbN0dB) ' dB']);
    xlim(axis_limits(1:2));
    
    y_min = min(imag(receivedPAMSignal));
    y_max = max(imag(receivedPAMSignal));
    y_range = y_max - y_min;
    ylim([y_min - 0.1*y_range, y_max + 0.1*y_range]); 
    
    grid on;
end



% MAP detector functions
function detectedQAMSymbols = mapDetectorQAM(receivedQAMSignal, modulationOrder)
    M = sqrt(modulationOrder);
    constellation = (2 * (0:M-1) - M + 1) + 1i * (2 * (0:M-1) - M + 1);
    detectedQAMSymbols = zeros(1, length(receivedQAMSignal));
    
    for i = 1:length(receivedQAMSignal)
        distances = abs(receivedQAMSignal(i) - constellation).^2;
        [~, minIndex] = min(distances);
        detectedQAMSymbols(i) = minIndex - 1;
    end
end

function detectedASKSymbols = mapDetectorASK(receivedASKSignal, modulationOrder)
    detectedASKSymbols = zeros(1, length(receivedASKSignal));
    
    for i = 1:length(receivedASKSignal)
        distances = abs(receivedASKSignal(i) - sqrt(2/modulationOrder) * cos(pi/modulationOrder * (0:modulationOrder-1))).^2;
        [~, minIndex] = min(distances);
        detectedASKSymbols(i) = minIndex - 1;
    end
end

function detectedFSKSymbols = mapDetectorFSK(receivedFSKSignal, modulationOrder)
    detectedFSKSymbols = zeros(1, length(receivedFSKSignal));
    
    for i = 1:length(receivedFSKSignal)
        distances= abs(receivedFSKSignal(i) - cos(2*pi*(1:modulationOrder)*i/length(receivedFSKSignal))).^2;
       [~, minIndex] = min(distances);
       detectedFSKSymbols(i) = minIndex - 1;
   end
end