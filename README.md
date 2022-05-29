# Octave IIR Filter Design Tool

## To Run

Simply run the gui.m file in octave everything is handeled within the GUI

## Filter Types

Here is a list of filter types this calculator can generate with what parameters are used. 
Note: Options do not show/hide based on filter type selection. Use the chart below to determin which parameters are used.

| Filter Type       | Sampleing Frequency (Fs)  | Center Frequenecy (Fc)   | Q Factor | Slope | Gain |
|-------------------|---------------------------|--------------------------|----------|-------|------|
| One Pole Lowpass   | Yes                        | Yes                       | No       | No    | No   |
| One Pole High Pass | Yes                        | Yes                       | No       | No    | No   | 
| LowPass 1p1z       | Yes                        | Yes                       | No       | No    | No   | 
| High Pass 1p1z     | Yes                        | Yes                       | No       | No    | No   | 
| Low Pass           | Yes                        | Yes                       | Yes      | No    | No   | 
| High Pass          | Yes                        | Yes                       | Yes      | No    | No   | 
| BandPass           | Yes                        | Yes                       | Yes      | No    | No   | 
| Notch              | Yes                        | Yes                       | Yes      | No    | No   | 
| Peak               | Yes                        | Yes                       | Yes      | No    | Yes  | 
| Low Shelf          | Yes                        | Yes                       | No       | Yes   | Yes  | 
| High Shelf         | Yes                        | Yes                       | No       | Yes   | Yes  | 
| Low Shelf 1st      | Yes                        | Yes                       | No       | No    | Yes  | 
| High Shelf 1st     | Yes                        | Yes                       | No       | No    | Yes  | 
| All Pass           | Yes                        | Yes                       | Yes      | No    | No   | 
| All Pass 1st       | Yes                        | Yes                       | No       | No    | No   | 

## Known Bugs

- [ ] Coursors don't disappear from previous plot after replotting new filter.

# Credits

- Calculations for filters other than lowshelf and high shelf were obtained from https://www.earlevel.com/main/2021/09/02/biquad-calculator-v3/
- Low shelf and high shelf equations obtained from https://webaudio.github.io/Audio-EQ-Cookbook/audio-eq-cookbook.html
- datacursor code created by Pantxo Diribarne see datacursor.m file.
