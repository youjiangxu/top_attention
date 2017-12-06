function  presave( name, varargin)
    if(nargin == 4)
        Quantization = varargin{1};
        Label        = varargin{2};
        Names        = varargin{3};
        save(name, 'Quantization', 'Label', 'Names', '-v7.3');
    end
end

