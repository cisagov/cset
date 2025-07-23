import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { FileDropDirective } from './file-drop.directive';
import { FileSelectDirective } from './file-select.directive';

@NgModule({
  imports: [ CommonModule ],
  declarations: [ FileDropDirective, FileSelectDirective ],
  exports: [ FileDropDirective, FileSelectDirective ]
})
export class FileUploadModule {
}
