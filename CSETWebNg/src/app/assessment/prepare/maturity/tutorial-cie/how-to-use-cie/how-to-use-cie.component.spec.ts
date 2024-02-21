import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HowToUseCieComponent } from './how-to-use-cie.component';

describe('HowToUseCieComponent', () => {
  let component: HowToUseCieComponent;
  let fixture: ComponentFixture<HowToUseCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [HowToUseCieComponent]
    });
    fixture = TestBed.createComponent(HowToUseCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
