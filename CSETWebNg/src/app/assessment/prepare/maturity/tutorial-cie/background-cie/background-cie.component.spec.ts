import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BackgroundCieComponent } from './background-cie.component';

describe('BackgroundCieComponent', () => {
  let component: BackgroundCieComponent;
  let fixture: ComponentFixture<BackgroundCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [BackgroundCieComponent]
    });
    fixture = TestBed.createComponent(BackgroundCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
