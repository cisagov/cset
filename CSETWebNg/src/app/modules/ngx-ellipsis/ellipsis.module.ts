import { NgModule } from '@angular/core';
import { EllipsisDirective } from './directives/ellipsis.directive';

@NgModule({
    imports: [EllipsisDirective],
    exports: [EllipsisDirective]
})
export class EllipsisModule { }