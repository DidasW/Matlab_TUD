function microLiter = calcVolume(L_mm, W_mm, H_micron)
    microLiter = L_mm/1e2 * W_mm/1e2 * H_micron/1e5 * 1e6;
end
