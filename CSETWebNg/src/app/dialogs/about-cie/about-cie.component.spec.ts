import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AboutCieComponent } from './about-cie.component';

describe('AboutCieComponent', () => {
  let component: AboutCieComponent;
  let fixture: ComponentFixture<AboutCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [AboutCieComponent]
    });
    fixture = TestBed.createComponent(AboutCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
