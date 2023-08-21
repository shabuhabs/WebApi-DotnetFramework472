#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019
ARG source
WORKDIR /inetpub/wwwroot

WORKDIR /app

RUN echo 'Installing signalfx-dotnet-tracing'

RUN Invoke-WebRequest -OutFile 'C:\app\signalfx-dotnet-tracing-1.1.0-x64.msi' -Uri 'https://github.com/signalfx/signalfx-dotnet-tracing/releases/download/v1.1.0/signalfx-dotnet-tracing-1.1.0-x64.msi' -UseBasicParsing

RUN ls c:/app/signalfx-dotnet-tracing-1.1.0-x64.msi

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Start-Process 'c:/app/signalfx-dotnet-tracing-1.1.0-x64.msi' '/qn' -PassThru | Wait-Process;


ENV COR_ENABLE_PROFILING="1"
ENV COR_PROFILER="{B4C89B0F-9908-4F73-9F59-0D77C5A06874}"
ENV CORECLR_ENABLE_PROFILING="1"
ENV CORECLR_PROFILER="{B4C89B0F-9908-4F73-9F59-0D77C5A06874}"
ENV SIGNALFX_SERVICE_NAME="MyWebApi"
ENV SIGNALFX_ENV="DotNetFramework472"
ENV SIGNALFX_PROFILER_ENABLED="true"
ENV SIGNALFX_PROFILER_MEMORY_ENABLED="true"
ENV SIGNALFX_METRICS_NetRuntime_ENABLED="true"
ENV SIGNALFX_METRICS_Process_ENABLED="true"
ENV SIGNALFX_METRICS_AspNetCore_ENABLED="true"
ENV SIGNALFX_METRICS_Traces_ENABLED="true"
ENV SIGNALFX_ACCESS_TOKEN="TOKEN"
ENV SIGNALFX_REALM="us1"
ENV CORECLR_PROFILER_PATH="C:\Program Files\SignalFx\.NET Tracing\SignalFx.Tracing.ClrProfiler.Native.dll"
ENV SIGNALFX_DOTNET_TRACER_HOME="C:\Program Files\SignalFx\.NET Tracing"
#enable debug logging
ENV SIGNALFX_TRACE_DEBUG="true"

COPY ${source:-obj/Docker/publish} .

ENTRYPOINT ["cmd.exe"]
