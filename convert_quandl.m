function datasets = convert_quandl(document)
% CONVERT_QUANDL Convert Quandl XML search results.
%   DATASETS = CONVERT_QUANDL(DOCUMENT) converts Quandl XML search results
%   from a document object model (DOM) node to a MATLAB structure. Field
%   names and the nesting of structures in DATASETS match the node names
%   and relationships in DOCUMENT.
%
%   Example:
%       query = 'http://www.quandl.com/api/v1/datasets.xml?query=IBM';
%       document = xmlread(query, 'Timeout', 10);
%       datasets = CONVERT_QUANDL(document);
%
%   See also GET_DATA_QUANDL.

%% File and license information.
%**************************************************************************
%
%   File:           convert_quandl.m
%   Module:         Input Analysis
%   Project:        Portfolio Optimisation
%   Workspace:      Finance Tools
%
%   Author:         Rodney Elliott
%   Date:           29 July 2014
%
%**************************************************************************
%
%   Copyright:      (c) 2014 Rodney Elliott
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program. If not, see <http://www.gnu.org/licenses/>.
%
%**************************************************************************

%% Parse input.
% CONVERT_QUANDL accepts a single input argument. Because the input
% argument contains data that is not easily decoded or checked, the
% 'inputParser' class and its methods are not used here.
if ~isa(document, 'org.apache.xerces.dom.DeferredDocumentImpl')
    error('convert_quandl:invalid_type', ...
        ['Invalid type. Function argument must be a valid document ' ...
        'object model (DOM) node.']);
end

%% Convert search results.
% Having located the root node of the DOM, child nodes are converted using
% the local function CONVERT_NODE. This operates recursively, starting at
% the root node and working its way down through the XML tree. Notice how
% CONVERT_NODE uses the attributes of a child node, in addition to the
% number of child nodes of the child node (aka grandchildren) to process
% the DOM.
root_node = document.getDocumentElement;
datasets = convert_node(root_node);

end

%% Local functions.
function s = convert_node(node)
children = node.getChildNodes;

if children.getLength == 0
    s = '';
    return
end

for i = 1:children.getLength
    child = children.item(i - 1);

    if child.getNodeType == 1
        child_name = char(child.getNodeName);
        child_name = matlab.lang.makeValidName(child_name);

        if child.hasAttributes
            attributes = child.getAttributes;
            
            if strcmp(char(attributes.item(0).getValue), 'array')
                s.(child_name) = convert_node(child);
            elseif strcmp(char(attributes.item(0).getValue), 'boolean')
                s.(child_name) = char(child.item(0).getData);
            elseif strcmp(char(attributes.item(0).getValue), 'integer')
                s.(child_name) = str2double(char(child.item(0).getData));
            else
                s.(child_name) = '';
            end
        else
            grandchildren = child.getChildNodes;
            
            if grandchildren.getLength > 2
                if exist('s', 'var')
                    row = length(s.(child_name));
                    s.(child_name)(row + 1) = convert_node(child);
                else
                    s.(child_name) = convert_node(child);
                end
            else
                if exist('s', 'var') && isfield(s, child_name)
                    row = size(s, 2);
                    s(row + 1).(child_name) = char(child.item(0).getData);
                else
                    try
                        s.(child_name) = char(child.item(0).getData);
                    catch
                        s.(child_name) = '';
                    end
                end
            end
        end
    end
end
end
