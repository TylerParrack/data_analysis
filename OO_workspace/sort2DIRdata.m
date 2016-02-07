function output = sort2DIRdata(input,varargin)
% SORT2DIRDATA sorts and compresses a 2D-IR data
% similar to that generated by LOAD2DIRDATA. Normal syntax, which will
% overwrite the old data structure, is:
%
%      data = sort2DIRdata(data);
%
% Some of the scripts I've written require sorted data.
% 
% using the 'sortby' input will allow you to sort the data by an arbitrary
% field (by default, it sorts by t2 time). e.g.,
%
%      data = sort2DIRdata(data,'sortby','scan_number');
%
% will sort the structure by the field 'scan_number'

sort_field = 't2';
while length(varargin)>=2 %using a named pair
  arg = varargin{1};
  val = varargin{2};
  switch lower(arg)
    case 'sortby'
    sort_field = val;
    if ~isfield(input,val)
        warning(['Unknown field to sort by',arg,'Sorting by t2'])
        sort_field = 't2';
    end
    otherwise
      warning(['sort2DIRdata: unknown option ',arg])
  end
  varargin = varargin(3:end);
end

empty_elems = arrayfun(@(s) all(structfun(@isempty,s)),input);
temp = input(~empty_elems);
uh = [temp.(sort_field)];
[~,ind] = sort(uh);
output = temp(ind);