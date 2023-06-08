## Copyright (C) 2022 Engineered Goose (engineeredgoose.com)
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

close all
clear h

graphics_toolkit qt

h.ax1 = axes ("position", [0.05 0.55 0.5 0.4]);
h.ax2 = axes ("position", [0.05 0.05 0.5 0.4]);
h.fcn = @(x) polyval([-0.1 0.5 3 0], x);

function update_plot (obj, init = false)

  ## gcbo holds the handle of the control
  h = guidata (obj);
  replot = false;
  recalc = false;
  filter_types = get(h.filter_type_popup, "string");
  dc_enable = get(h.dc_checkbox, "value");
  switch (gcbo)
    case {h.calculate_coeff}
      type = get(h.filter_type_popup, "value");
      fs = str2double(get(h.fs_edit, "string"));
      fc = str2double(get(h.fc_edit, "string"));
      q_factor = str2double(get(h.q_factor_edit, "string"));
      slope = str2double(get(h.slope_edit, "string"));
      peakGain = str2double(get(h.gain_edit, "string"));
      
      [b, a] = calc_biquad3(type, fc, fs, q_factor, slope, peakGain);
      float_str = sprintf("{%1.5f, %1.5f, %1.5f, %1.5f, %1.5f}", a(1), a(2), a(3), b(2), b(3));
      set(h.a0_edit, "string", float_str);

      a_q14 = to_fixed(a, 14);
      b_q14 = to_fixed(b, 14);
      q14_str = sprintf("{%d, %d, %d, %d, %d}", a_q14(1), a_q14(2), a_q14(3), b_q14(2), b_q14(3));
      set(h.a1_edit, "string", q14_str);
      
      a_q30 = to_fixed(a, 30);
      b_q30 = to_fixed(b, 30);
      q30_str = sprintf("{%d, %d, %d, %d, %d}", a_q30(1), a_q30(2), a_q30(3), b_q30(2), b_q30(3));
      set(h.a2_edit, "string", q30_str);
      
      [h2, w] = freqz(a, b , 4096);
      semilogx(h.ax1, (w/pi)*(fs/2), 20*log10(abs(h2)), "color", "blue");
      set (get (h.ax1, "title"), "string", "Gain (dB)");
      set (get (h.ax1, "xlabel"), "string", "Frequency (Hz)");
      set (get (h.ax1, "ylabel"), "string", "Gain (dB)");
      set (h.ax1, "ygrid",  "on");
      set (h.ax1, "xgrid",  "on");
      set (h.ax1, "xlim",  [0, fs/2]);
      semilogx(h.ax2, (w/pi)*(fs/2), rad2deg(atan2(imag(h2), real(h2))), "color", "blue");
      set (get (h.ax2, "title"), "string", "Phase (Degrees)");
      set (get (h.ax2, "xlabel"), "string", "Frequency (Hz)");
      set (get (h.ax2, "ylabel"), "string", "Phase (Degrees)");
      set (h.ax2, "ygrid",  "on");
      set (h.ax2, "xgrid",  "on");
      set (h.ax2, "xlim",  [0, fs/2]);
      if dc_enable
        datacursor;
      endif
  endswitch

endfunction

label_x = 0.63;
edit_x = 0.7;

function [label, edit] = add_editor(title, default_value, y_pos)
  label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", title,
                                "horizontalalignment", "right",
                                "position", [0.71 y_pos 0.07 0.08]);

  edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", default_value,
                                "horizontalalignment", "left",
                               "position", [0.8 y_pos 0.18 0.06]);                             
endfunction

[h.fs_label, h.fs_edit] = add_editor("Fs (Hz)", "10000", 0.9);
[h.fc_label, h.fc_edit] = add_editor("Fc (Hz)", "300", 0.82);
[h.q_factor_label, h.q_factor_edit] = add_editor("Q", "4.14", 0.74);
[h.slope_label, h.slope_edit] = add_editor("Slope", "10", 0.66);
[h.gain_label, h.gain_edit] = add_editor("Gain (db)", "-10", 0.58);


## filter type select
h.filter_type_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "Type",
                               "horizontalalignment", "right",
                               "position", [0.71 0.50 0.07 0.08]);

h.filter_type_popup = uicontrol ("style", "popupmenu",
                               "units", "normalized",
                               "string", {"one-pole lp",
                                          "one-pole hp",
                                          "lowpass 1p1z",
                                          "highpass 1p1z",
                                          "lowpass",
                                          "highpass",
                                          "bandpass",
                                          "notch",
                                          "peak",
                                          "lowShelf",
                                          "highShelf",
                                          "lowShelf 1st",
                                          "highShelf 1st",
                                          "allpass",
                                          "allpass 1st"},
                               "position", [0.8 0.50 0.18 0.06]);

## Calculate Coefficients
h.calculate_coeff = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Calculate",
                                "callback", @update_plot,
                                "position", [0.8 0.38 0.18 0.09]);


[h.a0_label, h.a0_edit] = add_editor("float", "", 0.30);
[h.a1_label, h.a1_edit] = add_editor("Q1.14", "", 0.22);
[h.a2_label, h.a2_edit] = add_editor("Q1.30", "", 0.14);

## data cursors
h.dc_checkbox = uicontrol ("style", "checkbox",
                             "units", "normalized",
                             "string", "Enable Data Cursors",
                             "value", 0,
                             "position", [0.7 0.05 0.3 0.09]);


set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (gcf, h)
update_plot (gcf, true);
