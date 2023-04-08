﻿FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["src/Coffee.MachineHttpApi/Coffee.MachineHttpApi.csproj", "src/Coffee.MachineHttpApi/"]
RUN dotnet restore "src/Coffee.MachineHttpApi/Coffee.MachineHttpApi.csproj"
COPY . .
WORKDIR "/src/src/Coffee.MachineHttpApi"
RUN dotnet build "Coffee.MachineHttpApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Coffee.MachineHttpApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Coffee.MachineHttpApi.dll"]
