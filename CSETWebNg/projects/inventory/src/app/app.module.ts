import { BrowserModule } from '@angular/platform-browser';
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { BrowserAnimationsModule} from '@angular/platform-browser/animations';
import { MatTabsModule, MatTabNav} from '@angular/material/tabs';
import { MatTableModule} from '@angular/material/table';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { ComponentsComponent } from './components/components.component';
import { LinksComponent } from './links/links.component';
import { NetworkWarningsComponent } from './network-warnings/network-warnings.component';
import { ShapesComponent } from './shapes/shapes.component';
import { TextComponent } from './text/text.component';
import { ZonesComponent } from './zones/zones.component';
import { InventoryConfigService } from './services/config.service';
import { DiagramService } from './services/diagram.service';




@NgModule({
  declarations: [
    AppComponent,
    ComponentsComponent,
    LinksComponent, 
    NetworkWarningsComponent,
    ShapesComponent, 
    TextComponent, 
    ZonesComponent
  ],
  imports: [
    AppRoutingModule,
    BrowserModule, 
    BrowserAnimationsModule, 
    MatTabsModule, 
    MatTableModule,
    FormsModule, 
    HttpModule, 
    HttpClientModule
  ],
  providers: [MatTabNav,
    InventoryConfigService,
        {
            provide: APP_INITIALIZER,
            useFactory: (configSvc: InventoryConfigService) => () => configSvc.loadConfig(),
            deps: [InventoryConfigService],
            multi: true
        }, 
      DiagramService
      
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
