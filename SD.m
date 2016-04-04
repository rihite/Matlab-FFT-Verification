%open input file and read values into input
fd=fopen('inputs.txt','r');
input = fscanf(fd,'%f');
fclose(fd);

%open outputs from hardware fft and read into outFromHW
fd=fopen('outputs.txt','r');
outFromHW = fscanf(fd,'%f');
fclose(fd);

%calculate number of floats in input.txt
len1 = length(input);
%calculate number of complex points
len2 = len1/2;

%initialize real and imaginary points
re1 = 1:len2;
im1 = 1:len2;
re2 = 1:len2;
im2 = 1:len2;

%read even values into real array and odd into imaginarly array
%values in input array alternate between real and imaginary
j=1;
for i = 1:len1
    %if i is even value is imaginary
    if (mod(i,2) == 0)
        im1(j)=input(i);
        j = j + 1;
    %if i is odd value is real
    else
        re1(j)=input(i);
    end
end

%read even values into real array and odd into imaginarly array
%values in outFromHW array alternate between real and imaginary
j=1;
for i = 1:len1
    %if i is even value is imaginary
    if (mod(i,2) == 0)
        im2(j)=outFromHW(i);
        j = j + 1;
    %if i is odd value is real
    else
        re2(j)=outFromHW(i);
    end
end

%cast real and imaginary arrays as a single complex array
cplxFromInput = complex(re1,im1);

%cast HW data as a single complex array
%data is already a FFT so no other operations on data necessary 
HWFFT = complex(re2,im2);
mag2 = sqrt(re2.^2 + im2.^2);

%perform fft on input data
matlabFFT=fft(cplxFromInput);

%calculate different between HW and Matlab FFT
diff = abs(matlabFFT)-abs(HWFFT);

%plot matlab fft data first
% title('FFT from Matlab', 'FontName', 'Times');
% xlabel('Sample Points');
% ylabel('FFT Magnitude');
subplot(3,1,1);
plot(abs(matlabFFT));

%plot fft data from HW second
subplot(3,1,2);
% title('FFT from HW Accelerator');
% xlabel('Sample Points');
% ylabel('FFT Magnitude');
plot(abs(matlabFFT));
plot(abs(HWFFT));

%plot the difference
subplot(3,1,3);
% title('Difference Between Matlab and HW');
% xlabel('Sample Points');
% ylabel('FFT Magnitude');
plot(abs(matlabFFT));
plot(diff);


