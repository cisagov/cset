import { Component } from '@angular/core';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ComponentsComponent } from './components/components.component';
import { ZonesComponent } from './zones/zones.component';
import { ShapesComponent } from './shapes/shapes.component';
import { TextComponent } from './text/text.component';
import { LinksComponent } from './links/links.component';
import { NetworkWarningsComponent } from './network-warnings/network-warnings.component';



const routes: Routes = [
    {
        path:'component', 
        component: ComponentsComponent
    },
    {
        path:'zones', 
        component: ZonesComponent
    },
    {
        path:'shapes', 
        component: ShapesComponent
    },
    {
        path: 'text',
        component: TextComponent
    },
    {
        path: 'links',
        component: LinksComponent
    },
    {
        path: 'network-warnings', 
        component: NetworkWarningsComponent
    },
    {
        path:'**',
        redirectTo:'component',
        pathMatch:'full'
    }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }