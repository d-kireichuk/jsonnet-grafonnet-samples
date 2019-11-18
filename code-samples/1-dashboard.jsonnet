local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local dashboard_title = 'Grafonnet test';
local dashboard_tags = ['grafonnet'];

//Add dashboard
dashboard.new(
    title=dashboard_title,
    tags=dashboard_tags,
    editable=true,
    time_from='now-1h',
    #time_to='now',
    #style='dark',
    #timezone='browser',
    #refresh='',
    #timepicker=timepickerlib.new(),
    #graphTooltip='default',
    #hideControls=false,
    #schemaVersion=14,
    #uid='',
    #description=null,
)   # + {foo: 'bar'} // In case you need some extra fields that are not currently supported by grafonnet.
