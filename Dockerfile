FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5108

ENV ASPNETCORE_URLS=http://+:5108

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["mrtunji.csproj", "./"]
RUN dotnet restore "mrtunji.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "mrtunji.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "mrtunji.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mrtunji.dll"]
