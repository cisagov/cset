import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LandingPageTabsComponent } from './landing-page-tabs.component';

describe('LandingPageTabsComponent', () => {
  let component: LandingPageTabsComponent;
  let fixture: ComponentFixture<LandingPageTabsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LandingPageTabsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LandingPageTabsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
