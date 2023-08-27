
// Définition d'un structure IUser
// A noter, le ? veut dire que le champ est optionnel

export interface IUser {
  id: number;
  nom?: string;
  prenom?: string;
  email: string;
  scope: 'user'|'admin';
  id_promo: number;
  id_instance: number;
  id_score:number
}

// Outils de manipulation des types :
// https://www.typescriptlang.org/docs/handbook/utility-types.html
// Ici, on rend tous les champs "lecture seul". Typescript ne va pas autoriser l'affectation des champs
export type IUserRO = Readonly<IUser>;

export type IUserCreate = Omit<IUser, 'id'>;

export type IUserUpdate = Partial<IUserCreate>;
