clc;
clear all;

numTransmittedSymbols = 1000;
modulationOrder = 16;
EbN0dBValues = [0, 4, 10];
maxIterations = 10000; 

errorProbQAM = zeros(size(EbN0dBValues));

for idx = 1:length(EbN0dBValues)
    iterationCount = 0;
    numErrorsQAM = 0;

    while iterationCount < maxIterations
        transmittedSymbols = randi([0 modulationOrder-1], 1, numTransmittedSymbols);
        qamModulatedSymbols = myQAMModulation(transmittedSymbols, modulationOrder);
        
        receivedSignal = addNoise(qamModulatedSymbols, EbN0dBValues(idx));
        
        detectedSymbols = myDetector(receivedSignal, modulationOrder);
    
        numErrorsQAM = numErrorsQAM + sum(detectedSymbols ~= transmittedSymbols);
        
        iterationCount = iterationCount + 1;
    end

    errorProbQAM(idx) = numErrorsQAM / (maxIterations * numTransmittedSymbols);
end

theoreticalErrorProbQAM = zeros(size(EbN0dBValues));
for idx = 1:length(EbN0dBValues)
    SNR = 10^(EbN0dBValues(idx)/10);
    SER = 2 * (1 - 1/sqrt(modulationOrder)) * qfunc(sqrt(3 * SNR * log2(modulationOrder) / (modulationOrder - 1)));
    theoreticalErrorProbQAM(idx) = SER;
end

% Plotting
figure;
semilogy(EbN0dBValues, errorProbQAM, 'bo-', 'LineWidth', 2);
hold on;
semilogy(EbN0dBValues, theoreticalErrorProbQAM, 'b--', 'LineWidth', 2);

grid on;
xlabel('Eb/No (dB)');
ylabel('Probability of Error (log scale)');
title('Probability of Error vs Eb/No');
legend('QAM Simulation', 'QAM Theory');

function receivedSignal = addNoise(signal, EbN0dB)
    snr = 10^(EbN0dB/10); 
    noisePower = 1 / snr; 
    noise = sqrt(noisePower) * randn(size(signal)); 
    receivedSignal = signal + noise; 
end

% Function for QAM modulation
function qamSymbols = myQAMModulation(data, modulationOrder)
    % Perform QAM modulation
    
    % Map data to QAM symbols (assuming Gray coding)
    qamSymbols = qammod(data, modulationOrder);
end

function detectedSymbols = myDetector(receivedSignal, modulationOrder)

    demodulatedSymbols = qamdemod(receivedSignal, modulationOrder);

    detectedSymbols = round(demodulatedSymbols);
end

%% Similarly i have done for FSK and ASK by manually changing and i ahve added plots in report