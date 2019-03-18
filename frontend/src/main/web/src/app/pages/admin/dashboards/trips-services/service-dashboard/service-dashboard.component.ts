import { Component, OnInit } from '@angular/core';
import { ApiDashboardService } from '../../../../../services/dashboards.service';
import { ServiceList, Service } from '../../../../../services/interfaces/service-dashboard.interface'
import { clone } from 'ramda';
import * as CanvasJS from '../../../../../../assets/js/canvasjs.min';
import {checkToken} from "../../../../../modules/api/index";
import { HttpResponse } from '@angular/common/http';

@Component({
  selector: 'app-service-dashboard',
  templateUrl: './service-dashboard.component.html',
  styleUrls: ['./service-dashboard.component.scss']
})
export class ServiceDashboardComponent implements OnInit {
  title = 'Services distribution';
  serviceData: ServiceList = {
    services: []
  };

  constructor(private serviceService: ApiDashboardService) { }

  buildChart(serviceData: ServiceList) {
    let chart = new CanvasJS.Chart("servicesChart", {
      animationEnabled: true,
      title:{
        text: "Services distribution",
        horizontalAlign: "center"
      },
      data: [{
        type: "doughnut",
        startAngle: 60,
        //innerRadius: 60,
        indexLabelFontSize: 17,
        indexLabel: "{label} - #percent%",
        toolTipContent: "<b>{label}:</b> {y} (#percent%)",
        dataPoints: []
      }]
    });
    serviceData.services.forEach(service => {
        chart.options.data[0].dataPoints.push({y: service.percentage, label: service.service_name})
    })

    chart.render();
  }

  ngOnInit() {
    this.serviceService.setServiceDistribution()
    .subscribe(
      (resp: HttpResponse<any>) => {
          checkToken(resp.headers);
          this.serviceData.services = clone(resp.body);
          this.buildChart(this.serviceData);
      },
      error => console.log(error)
  );
  }
}
