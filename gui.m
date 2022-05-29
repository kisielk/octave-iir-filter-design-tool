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

      set(h.a0_edit, "string", num2str(a(1), 5));
      set(h.a1_edit, "string", num2str(a(2), 5));
      set(h.a2_edit, "string", num2str(a(3), 5));
      set(h.b1_edit, "string", num2str(b(2), 5));
      set(h.b2_edit, "string", num2str(b(3), 5));
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


## sampling rate set Fs (Hz)
h.fs_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Fs (Hz)",
                                "horizontalalignment", "right",
                                "position", [0.63 0.895 0.07 0.08]);

h.fs_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "10000",
                                "horizontalalignment", "left",
                               "position", [0.7 0.90 0.22 0.06]);

## Cut off frequency Fc(Hz)
h.fc_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Fc (Hz)",
                                "horizontalalignment", "right",
                                "position", [0.63 0.84 0.07 0.07]);

h.fc_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "300",
                                "horizontalalignment", "left",
                               "position", [0.7 0.84 0.22 0.06]);

## Q factor
h.q_factor_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Q Factor",
                                "horizontalalignment", "right",
                                "position", [0.63 0.78 0.07 0.06]);

h.q_factor_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "4.14",
                                "horizontalalignment", "left",
                               "position", [0.7 0.78 0.22 0.06]);
## Slope
h.slope_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Slope",
                                "horizontalalignment", "right",
                                "position", [0.63 0.72 0.07 0.06]);

h.slope_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "10",
                                "horizontalalignment", "left",
                               "position", [0.7 0.72 0.22 0.06]);

## Gain (dB)
h.gain_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "Gain (dB)",
                                "horizontalalignment", "right",
                                "position", [0.60 0.66 0.1 0.06]);

h.gain_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "-10",
                                "horizontalalignment", "left",
                               "position", [0.7 0.66 0.22 0.06]);

## filter type select
h.filter_type_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "Type",
                               "horizontalalignment", "right",
                               "position", [0.60 0.60 0.1 0.06]);

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
                               "position", [0.7 0.60 0.22 0.06]);

## Calculate Coefficients
h.calculate_coeff = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Calculate Coefficients",
                                "callback", @update_plot,
                                "position", [0.6 0.45 0.35 0.09]);

## a0
h.a0_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "a0",
                                "horizontalalignment", "right",
                                "position", [0.60 0.35 0.1 0.06]);
h.a0_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "",
                                "horizontalalignment", "left",
                               "position", [0.7 0.35 0.22 0.06]);
## a1
h.a1_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "a1",
                                "horizontalalignment", "right",
                                "position", [0.60 0.30 0.1 0.06]);
h.a1_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "",
                                "horizontalalignment", "left",
                               "position", [0.7 0.30 0.22 0.06]);
## a2
h.a2_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "a2",
                                "horizontalalignment", "right",
                                "position", [0.60 0.25 0.1 0.06]);
h.a2_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "",
                                "horizontalalignment", "left",
                               "position", [0.7 0.25 0.22 0.06]);
## b1
h.b1_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "b1",
                                "horizontalalignment", "right",
                                "position", [0.60 0.20 0.1 0.06]);
h.b1_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "",
                                "horizontalalignment", "left",
                               "position", [0.7 0.20 0.22 0.06]);
## b2
h.b2_label = uicontrol ("style", "text",
                                "units", "normalized",
                                "string", "b2",
                                "horizontalalignment", "right",
                                "position", [0.60 0.15 0.1 0.06]);
h.b2_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "",
                                "horizontalalignment", "left",
                               "position", [0.7 0.15 0.22 0.06]);
## data cursors
h.dc_checkbox = uicontrol ("style", "checkbox",
                             "units", "normalized",
                             "string", "Enable Data Cursors",
                             "value", 0,
                             "position", [0.7 0.05 0.3 0.09]);


set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata (gcf, h)
update_plot (gcf, true);
