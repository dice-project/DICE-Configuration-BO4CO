classdef HttpService < handle
    properties (SetAccess = private)
        Name;
    end
    
    methods
        function httpResponse = service(obj, httpRequest)
            httpResponse = mls.internal.HttpResponse;
            if strcmpi(httpRequest.Method, 'get')
                obj.doGet(httpRequest, httpResponse);
            elseif strcmpi(httpRequest.Method, 'post')
                obj.doPost(httpRequest, httpResponse);
            end
        end
        
        function doGet(obj, ~, ~) %#ok<MANU>
        end
        
        function doPost(obj, ~, ~) %#ok<MANU>
        end
    end

    methods (Static, Sealed = true)
        function registerService(name, service)
            services = mls.internal.HttpService.getRegisteredServices;
            services(name) = service; %#ok<NASGU>
        end

        function deregisterService(name)
            services = mls.internal.HttpService.getRegisteredServices;
            if mls.internal.HttpService.getRegisteredServices.isKey(name)
                services.remove(name);
            end
        end

        function result = hasRegisteredService(name)
            result = mls.internal.HttpService.getRegisteredServices.isKey(name);
        end

        function service = getRegisteredService(name)
            if mls.internal.HttpService.getRegisteredServices.isKey(name)
                services = mls.internal.HttpService.getRegisteredServices;
                service = services(name);
            end
        end

        function services = getRegisteredServices
            services = getappdata(0, 'MLSERVER_SERVICES');
            if isempty(services)
                services = containers.Map;
                setappdata(0, 'MLSERVER_SERVICES', services);
            end
        end
    end
end