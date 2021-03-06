import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LandingComponent } from './pages/landing/landing.component';
import { NotFoundPageComponent } from './pages/not-found-page/not-found-page.component';
import { LoginComponent } from './pages/login/login.component';
import { RegistrationComponent } from './pages/registration/registration.component';
import { RecoveryComponent } from './pages/recovery/recovery.component';
import { ConfirmMessageComponent } from './pages/confirm-message/confirm-message.component';
import { ComingSoonComponent } from './pages/coming-soon/coming-soon.component';

import { Role } from './shared/guards/role';
import { AuthGuard } from './shared/guards/auth.guard';

const routes: Routes = [
  { path: '', component: LandingComponent},
  { path: 'notFound', component: NotFoundPageComponent},
  { path: 'login', component: LoginComponent},
  { path: 'sign-up', component: RegistrationComponent},
  { path: 'password-recovery', component: RecoveryComponent},
  { path: 'confirm', component: ConfirmMessageComponent},
  { path: 'in-design', component: ComingSoonComponent },
  { path: 'admin',
    loadChildren: './pages/admin/admin.module#AdminModule',
    canActivate: [AuthGuard],
    data: {roles: Role.Admin}
  },
  { path: 'trip-search',
    loadChildren: './pages/flights/flights.module#FlightsModule'
  },
  { path: 'carrier',
    loadChildren: './pages/carrier/carrier.module#CarrierModule',
    canActivate: [AuthGuard],
    data: {roles: Role.Carrier}
  },
  { path: 'approver',
    loadChildren: './pages/approver/approver.module#ApproverModule',
    canActivate: [AuthGuard],
    data: {roles: Role.Approver}
  },
  { path: 'flights',
    loadChildren: './pages/flights/flights.module#FlightsModule'
  },
  { path: 'user',
    loadChildren: './pages/user/user.module#UserModule',
    canActivate: [AuthGuard],
    data: {roles: Role.User}
  },
  { path: '**', redirectTo: '/notFound'}
];
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
