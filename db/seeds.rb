# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Create some multi country example banks
Bank.create([
  { slug: 'tangerine', name: 'Tangerine', currency: :cad },
  { slug: 'cibc', name: 'CIBC', currency: :cad },
  { slug: 'td', name: 'TD', currency: :cad },
  { slug: 'anz', name: 'ANZ', currency: :nzd },
  { slug: 'kiwibank', name: 'Kiwibank', currency: :nzd }
])

# Create basic categories
Category.create([
  { name: 'Housing', keywords: [] },
  { name: 'Bills & Utilities', keywords: ['insurance', 'fortis', 'hydro', 'spotify', 'mobile']},
  { name: 'Groceries', keywords: [] },
  { name: 'Transport', keywords: ['compass'] },
  {
    name: 'Health',
    keywords: ['health', 'dental', 'doctor']
  },
  { name: 'Hobbies & Entertainment', keywords: [] },
  { name: 'Shopping', keywords: [] },
  {
    name: 'Dining out',
    keywords: ['cafe', 'coffee', 'beer', 'burger', 'brewing']
  },
  { name: 'Vacation', keywords: [] },
  {
    name: 'Gifts/Donations',
    keywords: ['foundation']
  },
  { name: 'Transfers', keywords: ['payment'] },
  { name: 'Miscellaneous', keywords: [] },
  { name: 'Employment', transaction_type: :income, keywords: [] },
  { name: 'Interest & Dividends', transaction_type: :income, keywords: [] },
])
