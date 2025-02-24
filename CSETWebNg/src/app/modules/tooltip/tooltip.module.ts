import { NgModule, ModuleWithProviders } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TooltipDirective } from './tooltip.directive';
import { TooltipComponent } from './tooltip.component';
import { TooltipOptions } from './options.interface';
import { TooltipOptionsService } from './options.service';

@NgModule({
    declarations: [
        TooltipDirective,
        TooltipComponent
    ],
    imports: [
        CommonModule
    ],
    exports: [
        TooltipDirective
    ]
})
export class TooltipModule {

    static forRoot(initOptions: TooltipOptions): ModuleWithProviders<TooltipModule> {
        return {
            ngModule: TooltipModule,
            providers: [
                {
                    provide: TooltipOptionsService,
                    useValue: initOptions
                }
            ]
        };
    }
}
