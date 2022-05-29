function [b, a] = calc_biquad3(type, Fc, Fs, Q, slope, peakGain)
	V = (10^(abs(peakGain)/20));
	K = tan(pi * Fc / Fs);
	switch (type)
		case {1, "one-pole lp"}
			b1 = exp(-2.0 * pi * (Fc / Fs));
      a0 = 1.0 - b1;
      b1 = -b1;
			a1 = a2 = b2 = 0;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {2, "one-pole hp"}
			b1 = -exp(-2.0 * pi * (0.5 - Fc / Fs));
      a0 = 1.0 + b1;
      b1 = -b1;
			a1 = a2 = b2 = 0;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {3, "lowpass 1p1z"}
			norm = 1 / (1 / K + 1);
			a0 = a1 = norm;
			b1 = (1 - 1 / K) * norm;
			a2 = b2 = 0;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {4, "highpass 1p1z"}
			norm = 1 / (K + 1);
			a0 = norm;
			a1 = -norm;
			b1 = (K - 1) * norm;
			a2 = b2 = 0;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {5, "lowpass"}
			norm = 1 / (1 + K / Q + K * K);
			a0 = K * K * norm;
			a1 = 2 * a0;
			a2 = a0;
			b1 = 2 * (K * K - 1) * norm;
			b2 = (1 - K / Q + K * K) * norm;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {6, "highpass"}
			norm = 1 / (1 + K / Q + K * K);
			a0 = 1 * norm;
			a1 = -2 * a0;
			a2 = a0;
			b1 = 2 * (K * K - 1) * norm;
			b2 = (1 - K / Q + K * K) * norm;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {7, "bandpass"}
			norm = 1 / (1 + K / Q + K * K);
			a0 = K / Q * norm;
			a1 = 0;
			a2 = -a0;
			b1 = 2 * (K * K - 1) * norm;
			b2 = (1 - K / Q + K * K) * norm;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {8, "notch"}
			norm = 1 / (1 + K / Q + K * K);
			a0 = (1 + K * K) * norm;
			a1 = 2 * (K * K - 1) * norm;
			a2 = a0;
			b1 = a1;
			b2 = (1 - K / Q + K * K) * norm;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {9, "peak"}
			if (peakGain >= 0)
				norm = 1 / (1 + 1/Q * K + K * K);
				a0 = (1 + V/Q * K + K * K) * norm;
				a1 = 2 * (K * K - 1) * norm;
				a2 = (1 - V/Q * K + K * K) * norm;
				b1 = a1;
				b2 = (1 - 1/Q * K + K * K) * norm;
			else
				norm = 1 / (1 + V/Q * K + K * K);
				a0 = (1 + 1/Q * K + K * K) * norm;
				a1 = 2 * (K * K - 1) * norm;
				a2 = (1 - 1/Q * K + K * K) * norm;
				b1 = a1;
				b2 = (1 - V/Q * K + K * K) * norm;
			end
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {10, "lowShelf"}
      % function modeled after
      % https://webaudio.github.io/Audio-EQ-Cookbook/audio-eq-cookbook.html
      A = 10^(peakGain/40);
      w0 = 2*pi*(Fc/Fs);
      alpha = (sin(w0)/2)*sqrt((A+1/A)*(1/slope-1)+2);
      b0 = A*((A+1) - (A-1)*cos(w0)+2*sqrt(A*alpha));
      b1 = 2*A*((A-1)-(A+1)*cos(w0));
      b2 = A*((A+1)-(A-1)*cos(w0)-2*sqrt(A*alpha));
      a0 = (A+1) + (A-1)*cos(w0) + 2*sqrt(A*alpha);
      a1 = -2*((A-1) + (A+1)*cos(w0));
      a2 = (A+1)+(A-1)*cos(w0)-2*sqrt(A*alpha);
      a = [b0/a0, b1/a0, b2/a0];
      b = [a0/a0, a1/a0, a2/a0];

		case {11, "highShelf"}
      % function modeled after
      % https://webaudio.github.io/Audio-EQ-Cookbook/audio-eq-cookbook.html
      A = 10^(peakGain/40);
      w0 = 2*pi*(Fc/Fs);
      alpha = (sin(w0)/2)*sqrt((A+1/A)*(1/slope-1)+2);
      b0 = A*((A+1) + (A-1)*cos(w0)+2*sqrt(A*alpha));
      b1 = -2*A*((A-1)+(A+1)*cos(w0));
      b2 = A*((A+1)+(A-1)*cos(w0)-2*sqrt(A*alpha));
      a0 = (A+1) - (A-1)*cos(w0) + 2*sqrt(A*alpha);
      a1 = 2*((A-1) - (A+1)*cos(w0));
      a2 = (A+1)-(A-1)*cos(w0)-2*sqrt(A*alpha);
      a = [b0/a0, b1/a0, b2/a0];
      b = [a0/a0, a1/a0, a2/a0];

		case {12, "lowShelf 1st"}
			if (peakGain >= 0)
				norm = 1 / (K + 1);
				a0 = (K * V + 1) * norm;
				a1 = (K * V - 1) * norm;
				a2 = 0;
				b1 = (K - 1) * norm;
				b2 = 0;
			else
				norm = 1 / (K * V + 1);
				a0 = (K + 1) * norm;
				a1 = (K - 1) * norm;
				a2 = 0;
				b1 = (K * V - 1) * norm;
				b2 = 0;
			end
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {13, "highShelf 1st"}
      if (peakGain >= 0)
				norm = 1 / (K + 1);
				a0 = (K + V) * norm;
				a1 = (K - V) * norm;
				a2 = 0;
				b1 = (K - 1) * norm;
				b2 = 0;
			else
				norm = 1 / (K + V);
				a0 = (K + 1) * norm;
				a1 = (K - 1) * norm;
				a2 = 0;
				b1 = (K - V) * norm;
				b2 = 0;
			end
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {14, "allpass"}
			norm = 1 / (1 + K / Q + K * K);
			a0 = (1 - K / Q + K * K) * norm;
			a1 = 2 * (K * K - 1) * norm;
			a2 = 1;
			b1 = a1;
			b2 = a0;
      a = [a0, a1, a2];
      b = [1, b1, b2];

		case {15, "allpass 1st"}
			a0 = (1 - K) / (1 + K);
			a1 = -1;
			a2 = 0;
			b1 = -a0;
			b2 = 0;
      a = [a0, a1, a2];
      b = [1, b1, b2];
  end
 end

