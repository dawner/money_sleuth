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
  {name: 'Rent', keywords: []},
  { name: 'Utilities', keywords: []},
  { name: 'Groceries', keywords: []},
  { name: 'Transport', keywords: []},
  {
    name: 'Health',
    keywords: ['health', 'dental']
  },
  { name: 'Personal care', keywords: []},
  { name: 'Clothing/gear', keywords: []},
  {
    name: 'Dining out',
    keywords: ['cafe', 'coffee', 'beer', 'burger']
  },
  { name: 'Entertainment', keywords: []},
  { name: 'Travel', keywords: []},
  { name: 'Business expenses', keywords: []},
  {
    name: 'Gifts/Donations',
    keywords: ['foundation']
  },
  { name: 'Miscellaneous', keywords: []},
  { name: 'Saving', keywords: []}
])