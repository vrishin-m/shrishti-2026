import librosa, json, os
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, sosfilt, find_peaks
from scipy.ndimage import maximum_filter1d



def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    """Applies a Butterworth bandpass filter."""
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    # Ensure highcut does not exceed Nyquist frequency
    if high >= 1.0:
        high = 0.99
    sos = butter(order, [low, high], btype='band', output="sos")
    return sosfilt(sos, data)

def analyze_wave(y_abs, sr):
    min_gap = int(1 * sr) 
    f=100
    window=int(1*sr/f)
    print(window)
    # local_avg = np.convolve(y_abs[::f], np.ones(window)/window, mode='same')
    max_filtered = maximum_filter1d(y_abs, size=window*f)
    threshold = max_filtered 
    threshold_peaks, _ = find_peaks(y_abs, height=threshold, distance=min_gap)
    return threshold_peaks, threshold


BANDS = {
    "Sub": (20, 60),
    "Bass": (60, 500),
    "Mid": (500, 4000),
    "Treble": (4000, 20000)
}

def get_peaks(filename, show_graph=False):
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    audio_path = os.path.join(BASE_DIR, filename)
    print("Loading audio...", audio_path)
    y, sr = librosa.load(audio_path, sr=None)
    times = np.arange(len(y)) / sr

    data = {"sr":sr}

    energypertime = average_energy(y, sr)
    # print(len(y), len(times))
    # 3. Process and Plot
    if show_graph:
        plt.figure(figsize=(14, 10))

    for i, (name, (low, high)) in enumerate(BANDS.items(), 1):
        print(f"Processing {name} band...")
        
        filtered = butter_bandpass_filter(y, low, high, sr)

        # Normalize
        max_val = np.max(np.abs(filtered))
        if max_val>0:
            filtered = filtered/ max_val

        
        peaks, threshold = analyze_wave(np.abs(filtered), sr)
        
        data[name] = dict(zip(np.round(times[peaks], 2).tolist(), np.round(np.abs(filtered)[peaks], 2).tolist()))  # {time: amplitude}
        
        # Subplot generation
        if show_graph:
            plt.subplot(4, 1, i)
            plt.plot(times, np.abs(filtered), label=f"{name} Waveform", alpha=0.7, color='steelblue')
            plt.plot(times[peaks], np.abs(filtered)[peaks], "x", color='crimson', label=f"{name} Peaks")
            plt.plot(times, threshold, '--', color='orange', alpha=0.5, label="Adaptive Threshold")
            plt.title(f"{name} Band ({low}-{high} Hz)")
            plt.ylabel("Amplitude")
            plt.grid(True, linestyle='--', alpha=0.5)
            plt.legend(loc="upper right")
            
            if i == 4:
                plt.xlabel("Time (seconds)")


    import json
    with open("data.json", "w") as f:
        json.dump(data, f)

    print("Data saved!")

    if show_graph:
        plt.tight_layout()
        print("Rendering plot...")
        plt.show()
    
    return data, energypertime

def get_final_output(data):
    all_peaks = []
    for band, peaks in data.items():
        if band == "sr": continue
        # print(f"{band} peaks:")
        for time, amp in peaks.items():
            if amp>0.5:
                all_peaks.append((float(time), amp, band[0]))

    all_peaks.sort(key=lambda x: x[0]) 

    # for i in all_peaks:
    #     print(i)

    final_peaks = {}

    current_index = 0
    ahead_index = 1
    while current_index < len(all_peaks):
        current_time, current_amp, current_band = all_peaks[current_index]
        chars = current_band
        at=current_time
        add_time = current_time
        while ahead_index < len(all_peaks) and all_peaks[ahead_index][0] - current_time <= 1:
            ahead_time, ahead_amp, ahead_band = all_peaks[ahead_index]
            at =ahead_time
            # if (ahead_band == current_band):
            #     if ahead_amp > current_amp:
            #         chars = ahead_band

            delta_amp = abs(ahead_amp - current_amp)
            if delta_amp < 0.25: 
                # print(f"Merging peaks at {current_time:.2f}s and {ahead_time:.2f}s with amplitudes {current_amp:.2f} and {ahead_amp:.2f}")
                chars += ahead_band
            elif ahead_amp > current_amp:
                # print(f"Switching to higher amplitude peak at {ahead_time:.2f}s ({ahead_amp:.2f}) vs {current_time:.2f}s ({current_amp:.2f})")
                chars = ahead_band
                add_time = ahead_time
            else:
                # print(f"Keep higher amplitude peak at {current_time:.2f}s ({current_amp:.2f}) vs {ahead_time:.2f}s ({ahead_amp:.2f})")
                chars = current_band

            ahead_index += 1
        chars = ''.join(sorted(set(chars))) 
        
        final_peaks[add_time] = chars 
        current_index = ahead_index
        ahead_index = current_index + 1


    with open("final_peaks.json", "w") as f:
        json.dump(final_peaks, f)
    
    return final_peaks

def average_energy(y, sr, jump_time=1) -> np.ndarray:
    rms = librosa.feature.rms(y=y, frame_length=int(sr*jump_time), hop_length=int(sr*jump_time)).flatten()
    m=np.max(rms)
    rms = np.round(rms/m,2)
    # print(len(rms))
    return rms

