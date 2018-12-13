
% w is weight vector
% authentics and imposters are struct, name and matchVals
function w = getWeightForClass(authentics, imposters)

na = length(authentics);
ni = length(imposters);

% get ua (d dimensional mean of authentics)
ua = [];
% for every level
for level = 1:4
    levelAverage = 0;
    % using every auth, get average at level
    for i = 1:na
        levelAverage = levelAverage + authentics(i).matchVals(level);
    end
    levelAverage = levelAverage / ni;
    ua = [ua levelAverage];
end

% get ui (d dimensional mean of imposters)
ui = [];
for level = 1:4
    levelAverage = 0;
    for i = 1:ni
        levelAverage = levelAverage + imposters(i).matchVals(level);
    end
    levelAverage = levelAverage / ni;
    ui = [ui levelAverage];
end

% get sa (within class variance scatter for authentics)
sa = 0;
for i = 1:na
    % subtract d dimensional mean from each level
    v = authentics(i).matchVals - ua;
    wcv = v - ua;
    % (q-ua)(q-ua)T
    sa = sa + (wcv*transpose(wcv));
end

% get si (within class variance scatter for authentics)
si = 0;
for i = 1:ni
    % subtract d dimensional mean from each level
    wcv = imposters(i).matchVals - ui;
    % (q-ua)(q-ua)T
    si = si + (wcv*transpose(wcv));
end

% get with class scatter total
sw = sa + si;

% get between class scatter
sb = (ua-ui)*transpose(ua-ui);

% get weight
w = (sw^-1) * (ua-ui);

.5*(transpose(w))*(ua+ui);

(w * transpose(w) *sb)/(w * transpose(w) *sw) 

end


