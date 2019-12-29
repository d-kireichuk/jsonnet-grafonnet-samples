local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local dashboard_title = 'Grafonnet test';
local dashboard_tags = ['grafonnet'];
local variables = import '4-variables.jsonnet';
local panels = import '4-panels.jsonnet';

//Add dashboard
dashboard.new(title=dashboard_title,tags=dashboard_tags,editable=true,time_from='now-1h')
.addTemplates(variables.vars)
.addPanels(panels.panels)