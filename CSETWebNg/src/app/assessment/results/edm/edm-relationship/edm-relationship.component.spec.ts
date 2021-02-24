import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EdmRelationshipComponent } from './edm-relationship.component';

describe('EdmRelationshipComponent', () => {
  let component: EdmRelationshipComponent;
  let fixture: ComponentFixture<EdmRelationshipComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EdmRelationshipComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EdmRelationshipComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
