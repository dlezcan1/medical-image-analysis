function info = parse_patientinfo(file)
    arguments
        file string;
    end
    
    lines = splitlines(string(fileread(file)));
    lines = strrep(lines, ':', '');
    
    for i = 1:numel(lines)
        line_i = lines(i);
        
        scan_i = textscan(line_i, '%s');
        
        if isempty(scan_i{1})
            continue;
        end
        
        key = scan_i{1}{1};
        val = scan_i{1}{2};
        
        [val_num, val_isnum] = str2num(val);
        
        if val_isnum
            info.(key) = val_num;
        else
            info.(key) = val;
        end
    end
end    