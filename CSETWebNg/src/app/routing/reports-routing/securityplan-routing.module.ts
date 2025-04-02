import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SecurityplanComponent } from '../../reports/securityplan/securityplan.component';

const routes: Routes = [
    {
        path: '',
        component: SecurityplanComponent,
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class SecurityPlanRoutingModule { }