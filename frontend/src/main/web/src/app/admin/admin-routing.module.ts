import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { IndexComponent } from './index/index.component';
import { ApproverCrudComponent } from './approver/approver-crud/approver-crud.component';
import { CarrierCrudComponent } from './carrier-crud/carrier-crud.component';
import { BundlesCrudComponent } from './bundles/bundles-crud/bundles-crud.component';
import { DashboardsComponent } from './dashboards/dashboards.component';
import { UserDetailsComponent } from './user-details/user-details.component';

const routes: Routes = [
  {
      path: '',
      component: IndexComponent
  },
  {
      path: 'approvers',
      component: ApproverCrudComponent
  },
  {
      path: 'carriers',
      component: CarrierCrudComponent
  },
  {
      path: 'bundles',
      component: BundlesCrudComponent
  },
  {
      path: 'dashboards',
      component: DashboardsComponent
  },
  {
      path: 'user-details/:id',
      component: UserDetailsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminRoutingModule { }
