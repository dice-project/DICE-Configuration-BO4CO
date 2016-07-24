classdef FevalService < mls.internal.HttpService
    properties (SetAccess = private)
        WhiteList;
    end

    methods
        function service = FevalService(varargin)
            % Check if connector config contains an override for the white list
            if nargin == 1
                service.WhiteList = varargin{1};
            else
                service.WhiteList = {};
            end

            mls.internal.HttpService.registerService('feval', service);
        end

        function doGet(obj, httpRequest, httpResponse)
            pathParts = regexp(httpRequest.Path, '/', 'split');

            if numel(pathParts) == 2
                % check the whitelist if there is one, if it's empty
                % allow all functions
                allowed = true;
                for i = 1:numel(obj.WhiteList)
                    if strcmp(obj.WhiteList{i}, pathParts{2})
                        allowed = true;
                        break;
                    end
                    allowed = false;
                end

                if allowed
                    decoder = java.net.URLDecoder;
                    arguments = '';
                    if httpRequest.Parameters.isKey('arguments')
                        arguments = char(decoder.decode(httpRequest.Parameters('arguments')));
                    end
                    outputs = 0;
                    if httpRequest.Parameters.isKey('nargout')
                        outputs = str2double(char(decoder.decode(httpRequest.Parameters('nargout'))));
                    end

                    results = mls.internal.fevalJSON(pathParts{2}, arguments, outputs);

                    if outputs > 0
                        httpResponse.Data = unicode2native(results,'utf-8');
                        httpResponse.ContentType = 'application/json;charset=utf-8';
                    else
                        httpResponse.ContentType = 'text/html';
                        httpResponse.StatusCode = 204;
                    end
                else
                    httpResponse.StatusCode = 404;
                end
            end
        end

        function doPost(obj, httpRequest, httpResponse)
			doGet(obj, httpRequest, httpResponse);
        end
    end
end
