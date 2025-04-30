import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TutorialCisComponent } from '../../assessment/prepare/maturity/tutorial-cis/tutorial-cis.component';
import { TutorialCmmcComponent } from '../../assessment/prepare/maturity/tutorial-cmmc/tutorial-cmmc.component';
import { TutorialCmmc2Component } from '../../assessment/prepare/maturity/tutorial-cmmc2/tutorial-cmmc2.component';
import { TutorialCpgComponent } from '../../assessment/prepare/maturity/tutorial-cpg/tutorial-cpg.component';
import { TutorialCrrComponent } from '../../assessment/prepare/maturity/tutorial-crr/tutorial-crr.component';
import { TutorialEdmComponent } from '../../assessment/prepare/maturity/tutorial-edm/tutorial-edm.component';
import { TutorialImrComponent } from '../../assessment/prepare/maturity/tutorial-imr/tutorial-imr.component';
import { TutorialMvraComponent } from '../../assessment/prepare/maturity/tutorial-mvra/tutorial-mvra.component';
import { TutorialRraComponent } from '../../assessment/prepare/maturity/tutorial-rra/tutorial-rra.component';


const routes: Routes = [
    { path: 'tutorial-cmmc', component: TutorialCmmcComponent },
    { path: 'tutorial-cmmc2', component: TutorialCmmc2Component },
    { path: 'tutorial-edm', component: TutorialEdmComponent },
    { path: 'tutorial-crr', component: TutorialCrrComponent },
    { path: 'tutorial-imr', component: TutorialImrComponent },
    { path: 'tutorial-rra', component: TutorialRraComponent },
    { path: 'tutorial-cis', component: TutorialCisComponent },
    { path: 'tutorial-cpg', component: TutorialCpgComponent },
    { path: 'tutorial-mvra', component: TutorialMvraComponent }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class AssessmentTutorialRoutingModule { }