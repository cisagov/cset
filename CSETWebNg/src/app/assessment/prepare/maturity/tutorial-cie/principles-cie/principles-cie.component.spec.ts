import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PrinciplesCieComponent } from './principles-cie.component';

describe('PrinciplesCieComponent', () => {
  let component: PrinciplesCieComponent;
  let fixture: ComponentFixture<PrinciplesCieComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [PrinciplesCieComponent]
    });
    fixture = TestBed.createComponent(PrinciplesCieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
