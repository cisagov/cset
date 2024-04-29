import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CiePrincipleOnlyComponent } from './cie-principle-only.component';

describe('CiePrincipleOnlyComponent', () => {
  let component: CiePrincipleOnlyComponent;
  let fixture: ComponentFixture<CiePrincipleOnlyComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [CiePrincipleOnlyComponent]
    });
    fixture = TestBed.createComponent(CiePrincipleOnlyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
