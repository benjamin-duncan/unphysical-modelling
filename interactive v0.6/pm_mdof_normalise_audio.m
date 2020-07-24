function [normal_audio] =pm_mdof_normalise_audio(audio)

try
    % remove DC offset

    dc_audio = audio - mean(audio);

    % normalise all audio to 0dB 
    % remove any clipping or inrease gain if signal is quiet

    if (max(dc_audio) > 1 || min(dc_audio) < -1)

        if (max(dc_audio) > abs(min(dc_audio)))
        normal_audio = dc_audio.*(1/max(dc_audio));
        else
        normal_audio = dc_audio.*(1/abs(min(dc_audio)));    
        end

    else
        if (max(dc_audio) > abs(min(dc_audio)))
        normal_audio = dc_audio.*(1/max(dc_audio));
        else
        normal_audio = dc_audio.*(1/abs(min(dc_audio)));    
        end

    end

catch e
    error('pm_mdof_normalise_audio : %s',e.message);
end
end