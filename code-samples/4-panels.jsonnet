local grafana = import 'grafonnet/grafana.libsonnet';
local mapping = import '4-instance-mapping.jsonnet';
local instance_group_mapping = mapping.instance_group_mapping;
local graphPanel = grafana.graphPanel;
local cw = grafana.cloudwatch;
local aws_region = 'eu-west-1';
local period = '1m';
local network_metrics = ['NetworkIn', 'NetworkOut'];
local disk_metrics = ['EBSWriteOps', 'EBSReadOps'];

local cw_target = {
  attributes(alias,metric,namespace='AWS/EC2',dimensions)::
  cw.target(
    alias=alias,
    region=aws_region,
    namespace=namespace,
    metric=metric,
    dimensions=dimensions,
    period=period
  )
};

//Custom function for adding CPUUtilization panels
local cpu_panel = {
  attributes(group)::
  graphPanel.new(
    title='CPU %s' % group,
    datasource='$datasource',
    format='percent',
    nullPointMode='connected',
    min=0,
    max=100,
    decimals=0,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
  )
  .addTargets(
    [cw_target.attributes(
      metric='CPUUtilization',
      dimensions={'InstanceId': '$ec2_id_%s' % instance.var_name_ec2_id},
      alias=instance.instance_name
      ) for instance in instance_group_mapping if instance.group_name == group
    ]
  ) +
  {
    fillGradient: '7',
    gridPos: {h:11, w:8}
  },
};

//Custom function for adding Networking panels
local network_panel = {
  attributes(instance_name, var_name)::
  graphPanel.new(
    title='Network %s' % instance_name,
    datasource='$datasource',
    format='bytes',
    nullPointMode='connected',
    decimals=1,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    aliasColors={
      'NetworkIn': 'dark-blue',
      'NetworkOut': 'super-light-blue',
    }  
  )
  .addSeriesOverride({'alias': '/.*Out.*/', 'transform': 'negative-Y'})
  .addTargets(
    [cw_target.attributes(metric='%s' % metric,dimensions={'InstanceId': '$ec2_id_%s' % var_name},
      alias='{{metric}}') for metric in network_metrics
    ]
  ) + {fillGradient: '7', gridPos: {h:11, w:8, x:8}},
};

//Custom function for adding DiskOps panels
local disk_panel = {
  attributes(instance_name, var_name)::
  graphPanel.new(
    title='Disk Ops %s' % instance_name,
    datasource='$datasource',
    format='short',
    nullPointMode='connected',
    decimals=1,
    lines=false,
    bars=true,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    aliasColors={
      'EBSWriteOps': 'dark-orange',
      'EBSReadOps': 'super-light-orange',
    }  
  )
  .addSeriesOverride({'alias': '/.*Read.*/', 'transform': 'negative-Y'})
  .addTargets(
    [cw_target.attributes(metric='%s' % metric,dimensions={'InstanceId': '$ec2_id_%s' % var_name},
      alias='{{metric}}') for metric in disk_metrics
    ]
  ) + {gridPos: {h:11, w:8, x:16}},
};

//Resulting array containing panels object which is imported to dashboard.jsonnet
{
  panels: 
  [cpu_panel.attributes(group=group.group_name) for group in instance_group_mapping if group.group_lead] +
  [network_panel.attributes(instance_name=instance.instance_name,var_name=instance.var_name_ec2_id) for instance in instance_group_mapping] +
  [disk_panel.attributes(instance_name=instance.instance_name,var_name=instance.var_name_ec2_id) for instance in instance_group_mapping]
}
