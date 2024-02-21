import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LifecycleCieComponent } from './lifecycle-cie.component';

describe('LifecycleCieComponent', () => {
  let component: LifecycleCieComponent;
  let fixture: ComponentFixture<LifecycleCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [LifecycleCieComponent]
    });
    fixture = TestBed.createComponent(LifecycleCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
