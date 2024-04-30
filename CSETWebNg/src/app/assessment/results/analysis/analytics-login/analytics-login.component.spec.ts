import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AnalyticsLoginComponent } from './analytics-login.component';

describe('AnalyticsLoginComponent', () => {
  let component: AnalyticsLoginComponent;
  let fixture: ComponentFixture<AnalyticsLoginComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [AnalyticsLoginComponent]
    });
    fixture = TestBed.createComponent(AnalyticsLoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
