import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EdmComponent } from '../../reports/edm/edm.component';

const routes: Routes = [
    {
        path: '',
        component: EdmComponent,
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class EdmRoutingModule { }