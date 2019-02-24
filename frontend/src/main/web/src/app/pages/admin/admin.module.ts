import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';

import {AdminRoutingModule} from './admin-routing.module';
import {NavbarComponent} from './navbar/navbar.component';
import {IndexComponent} from './index/index.component';
import {ApproverCrudComponent} from './approver/approver-crud/approver-crud.component';
import {CarrierCrudComponent} from './carrier/carrier-crud/carrier-crud.component';
import {DashboardsComponent} from './dashboard/dashboards/dashboards.component';
import {BundlesCrudComponent} from './bundles-crud/bundles-crud.component';
import {ApproverComponentComponent} from './approver/approver-component/approver-component.component';
import {ApproverTableComponent} from './approver/approver-table/approver-table.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { FilterPipePipe } from './approver/shared/pipes/filter-pipe.pipe';
import { AprroverShowStatusPipe } from './approver/shared/pipes/aprrover-show-status.pipe';
import { TripsServicesComponent } from './dashboards/trips-services/trips-services.component';
import { TripDashboardComponent } from './dashboards/trips-services/trip-dashboard/trip-dashboard.component';
import { ServiceDashboardComponent } from './dashboards/trips-services/service-dashboard/service-dashboard.component';

import { DashboardDeltaComponent } from './dashboard/dashboard-delta/dashboard-delta.component';
import { TroubleStatisticsComponent } from './dashboard/trouble-statistics/trouble-statistics.component';
import { CarrierShowStatusPipe } from './carrier/carrier-show-status.pipe';
import { CommonChartComponent } from './dashboard/common-chart/common-chart.component';
import { CarCostDashComponent } from './dashboard/car-cost-dash/car-cost-dash.component';
import { CarrierComponentComponent } from './carrier/carrier-component/carrier-component.component';
import { CarrierTableComponent } from './carrier/carrier-table/carrier-table.component';

import { TroubleStatisticsService } from './dashboard/trouble-statistics.service';

@NgModule({
  declarations: [
    NavbarComponent,
    ApproverCrudComponent,
    IndexComponent,
    CarrierCrudComponent,
    BundlesCrudComponent,
    DashboardsComponent,
    ApproverComponentComponent,
    ApproverTableComponent,
    ApproverCrudComponent,
    FilterPipePipe,
    AprroverShowStatusPipe,
    TripsServicesComponent,
    TripDashboardComponent,
    ServiceDashboardComponent,
    DashboardDeltaComponent,
    TroubleStatisticsComponent,
    CarrierComponentComponent,
    CarrierTableComponent,
    CarrierShowStatusPipe,
    CommonChartComponent,
    CarCostDashComponent
  ],
  imports: [
    CommonModule,
    AdminRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ],
  providers: [
    FilterPipePipe,
    TroubleStatisticsService,
  ]
})
export class AdminModule {
}
