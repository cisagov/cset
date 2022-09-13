import { HttpClient, HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { SortablejsModule } from 'ngx-sortablejs';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ListItemsComponent } from './list-items/list-items.component';
import { GalleryEditorService } from './services/gallery-editor.service';



@NgModule({
  declarations: [
    AppComponent,
    ListItemsComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FontAwesomeModule,
    
    SortablejsModule.forRoot({ animation: 150 }),
  ],
  providers: [
    GalleryEditorService,
    HttpClient
  ],
  bootstrap: [AppComponent]
})
export class AppModule { 
}
